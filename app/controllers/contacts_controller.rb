class ContactsController < ApplicationController
  # GET request to /contact-us
  # Show new contact form
  def new
    @contact = Contact.new
  end

  # POST request to /contacts
  def create
      # Mass assignment of form field into Contact object
      @contact = Contact.new(contact_params)
      # Save the Contact object to the database
      if @contact.save
          # Store form fields via parameters, into variables
          name = params[:contact][:name]
          email = params[:contact][:email]
          body = params[:contact][:comments]

          # Plus variables into the Contact Mailer email Method and send email
          ContactMailer.contact_email(name, email, body).deliver

          # Store success message in flash hash
          # and redirect to the new action
          flash[:success] = "Message sent."
          redirect_to contacts_path
      else
          # If Contact Object doesn't save
          # Store errors in flash hash
          # and redirect to the new action
          flash[:danger] = @contact.errors.full_messages.join(", ")
          redirect_to contacts_path
      end
  end

  private
    # To collect data from forms we need to use strong parameters
    # and whitelist the form fields
    def contact_params
        params.require(:contact).permit(:name, :email, :comments)
    end
end
