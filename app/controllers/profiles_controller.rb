class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile # or wherever the profile is attached to user
  end
  # GET request from /users/:user_id/profile/new
  def new
    # Render a blank profile details forms
    @profile = Profile.new
  end
  # POST to /users/:user_id/profile
  # def create
  #   # Ensure that we have the user who is filling out form
  #   @user = User.find(params[:user_id])
  #   # Create profile linked to this specific user
  #   @profile = @user.build_profile(profile_params)
  #   if @profile.save
  #     flash[:success] = "Profile updated!"
  #     redirect_to user_path(id: params[:user_id])
  #   else
  #     render action: :new
  #   end
  # end

  # def create
  #   @user = User.find(params[:user_id])
  #   @profile = @user.build_profile(profile_params)
  #   puts "Profile: #{@profile.inspect}"
  #   if @profile.save
  #     puts "Profile saved successfully!"
  #     flash[:success] = "Profile updated!"
  #     redirect_to user_path(id: params[:user_id])
  #   else
  #     puts "Profile errors: #{@profile.errors.full_messages.inspect}"
  #     flash.now[:error] = @profile.errors.full_messages.join(", ")
  #     render action: :new, status: :unprocessable_entity
  #   end
  # end

  def create
    @user = User.find(params[:user_id])
    ActiveRecord::Base.transaction do
      @profile = @user.build_profile(profile_params)
      if @profile.save
        flash[:success] = "Profile updated!"
        redirect_to user_path(id: params[:user_id])
      else
        flash.now[:error] = @profile.errors.full_messages.join(", ")
        render action: :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback # Ensure rollback on validation failure.
      end
    end
  rescue => e
    Rails.logger.error "Profile creation error: #{e.message}\n#{e.backtrace.join("\n")}"
    render :new, status: :internal_server_error
  end

  # GET request to /users/:user_id/profile/edit
  def edit
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def update
    # Retrieve user from the database
    @user = User.find(params[:user_id])
    # Retrieve user's profile
    @profile = @user.profile
    # Mass assign edited profile attributes and save (update)
    if @profile.update(profile_params)
      flash[:success] = "Profile Updated!"
      # Redirect user to their profile page
      redirect_to user_profile_path(id: params[:user_id])
    else
      render action: :edit
    end
  end

  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
  end
end
