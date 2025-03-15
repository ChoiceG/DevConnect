# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  port: 587,
  address: "smtp.mailgun.org",
  username: ENV["MAILGUN_SMTP_USERNAME"],
  password: ENV["MAILGUN_SMTP_PASSWORD"],
  domain: "devconnect-d0xo.onrender.com", # Correct domain (no http/https)
  authentication: :plain
}

ActionMailer::Base.delivery_method = :smtp
