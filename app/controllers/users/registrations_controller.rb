class Users::RegistrationsController < Devise::RegistrationsController
  before_action :validate_plan, only: [ :new, :create ]  # Ensure we validate the plan before creating the user

  # GET /users/sign_up
  def new
    super
  end

  # POST /users
  def create
    # Fetch the plan using the plan ID passed in the params
    @plan = Plan.find_by(id: params[:plan])

    # If no plan is found, add an error and re-render the form
    if @plan.nil?
      flash[:alert] = "Please select a valid membership plan (Basic or Pro)."
      redirect_to new_user_registration_path and return
    end

    # Create a new user with the provided user parameters
    @user = User.new(user_params)
    @user.plan = @plan  # Associate the selected plan with the user

    if @user.save
      # If the user is successfully created, handle Stripe subscription and other logic
      create_stripe_subscription(@user, @plan)

      # Automatically sign the user in
      sign_in(@user)

      # Redirect the user to the homepage with a success notice
      redirect_to root_path, notice: "Account created successfully!"
    else
      render :new
    end
  end

  private

  # Strong parameters: only allow specific user attributes to be submitted
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # This method ensures that the user selects a valid plan
  def validate_plan
    plan_id = params[:plan]
    unless plan_id && (plan_id == "1" || plan_id == "2")
      flash[:alert] = "Please select a valid membership plan (Basic or Pro)."
      redirect_to root_path
    end
  end

  # Method to handle Stripe subscription creation based on the selected plan
  def create_stripe_subscription(user, plan)
    begin
      # Create a Stripe customer using the user's email and payment method token (from Stripe.js)
      customer = Stripe::Customer.create(
        description: user.email,
        email: user.email,
        source: params[:stripeToken]  # The Stripe token for the payment method
      )

      # Save the Stripe customer ID for future reference
      user.stripe_customer_token = customer.id

      # Handle subscriptions based on the selected plan (Pro or Basic)
      if plan.id == 2  # Pro plan
        subscription = Stripe::Subscription.create(
          customer: customer.id,
          items: [ { price: "price_1QdCqEE1sSOCEmuor86NKBoA" } ]  # Pro plan price ID
        )
        user.stripe_subscription_id = subscription.id
      elsif plan.id == 1  # Basic plan
        price_id_basic = "price_1QdCpiE1sSOCEmuo4RN4elGq"  # Basic plan price ID
        subscription = Stripe::Subscription.create(
          customer: customer.id,
          items: [ { price: price_id_basic } ]
        )
        user.stripe_subscription_id = subscription.id
      end

      # Save the updated user with the Stripe customer and subscription info
      user.save!
    rescue Stripe::StripeError => e
      user.errors.add(:base, "Stripe error: #{e.message}")
      render :new
    rescue => e
      user.errors.add(:base, "There was an error processing your request: #{e.message}")
      render :new
    end
  end
end
