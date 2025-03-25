DevConnect is a full-stack web application designed to help users create and manage their professional profiles. The platform features subscription-based plans with different access levels, allowing users to upgrade to a pro account for enhanced features. It includes user authentication, payment processing, image storage, email communication, and more.

<<<<<<< HEAD
Table of Contents
Introduction
Technologies Used
Features
Setup Instructions
Configuration
Running the Application Locally
Running the Test Suite
Deployment Instructions (Render)
Contributing
License

INTRODUCTION
DevConnect is a platform that allows users to build and manage their professional profiles with various access levels. It offers the following features:
Secure authentication using Devise.
Payment integration with Stripe to manage subscriptions.
Image storage on AWS S3 using ActiveStorage.
Email notifications powered by Mailgun.
A responsive and modern UI built with Bootstrap. Users can choose between two plans: a free basic plan with limited profile information visibility and a pro plan with full access to other users' contact details.

TECHNOLOGIES USED
Ruby on Rails (Back-end)
JavaScript (Front-end interactivity)
PostgreSQL (Database)
Devise (Authentication)
Stripe (Payment processing)
AWS S3 (File storage)
Mailgun (Email notifications)
Bootstrap (Responsive UI design)
RSpec (Testing)
Render (Deployment)

FEATURES
User Authentication: Secure user registration and login via Devise.
Subscription Plans: Two user tiers: Basic (free) and Pro (paid via Stripe).
File Uploads: Profile images stored using AWS S3 via ActiveStorage.
Email Notifications: Contact us using Mailgun.
Responsive UI: The app is mobile-friendly and adapts to various screen sizes using Bootstrap.
User Profiles: Users can view and manage their profile details, which can be private or public depending on their subscription plan.

SETUP INSTRUCTIONS
To get started with DevConnect on Windows, follow these steps to set up the development environment.
Install Prerequisites Before installing Ruby on Rails, make sure you have Node.js and Yarn already installed on your computer. You can download them from the following links: 
    Node.js: Download Node.js 
    Yarn: Download Yarn

Install Ruby Download Ruby from https://rubyinstaller.org/. Run the installer and follow the prompts to install Ruby on your system. After installation, open Command Prompt or your coding environment (e.g., VSCode), and verify the installation by running: 
    ruby -v 
You should see something like: 
    ruby 3.3.6 
This confirms that Ruby is correctly installed.

Install Rails Once Ruby is installed, open Command Prompt or your coding environment terminal and run the following command to install Rails: 
    gem install rails 
After installation is complete, verify that Rails was installed correctly by running: 
    rails -v 
You should see: 
    Rails 8.0.1 
This confirms that Rails has been installed successfully.

SET UP PostgreSQL 
DevConnect uses PostgreSQL as its database. If you don't have PostgreSQL installed yet, you can download it from PostgreSQL Official Site - https://www.postgresql.org/download/windows/. 
Follow these steps to set up PostgreSQL: 
Download and install PostgreSQL from the link above. During installation, make sure to take note of the password you set for the postgres user. Once installed, verify PostgreSQL is working by opening the SQL Shell and running: 
    psql -U postgres 
You'll be prompted for the password you set during installation.

SET UP YOUR RAILS PROJECT WITH PostgreSQL 
Now that you have Ruby, Rails, and PostgreSQL installed, you can create a new Rails application with PostgreSQL as the database. 
Open your terminal and run the following command: 
    rails new DevConnect --database=postgresql 
This will create a new Rails application named DevConnect configured to use PostgreSQL as the database.

Configure Your Database Once the Rails app has been created, navigate to the project directory: 
    cd DevConnect 
Now, configure your database: 
    Open config/database.yml and ensure the development and test databases are set up with the correct username and password for PostgreSQL (the default is usually postgres).

Example: 
development: 
<<: *default 
database: devconnect_development 
username: postgres 
password: your_postgresql_password

test: 
<<: *default 
database: devconnect_test 
username: postgres 
password: your_postgresql_password

Create the databases by running the following command: 
    rails db:create
Run the migrations: 
    rails db:migrate 
Now, your database is set up and ready to go!

Install JavaScript Dependencies DevConnect uses Yarn to manage JavaScript packages. To install all necessary JavaScript dependencies, run: 
    yarn install

START THE RAILS SERVER 
Finally, you can start the Rails server: 
    bundle exec rails s 
    Visit http://localhost:3000 in your browser to view the application.

CONFIGURATION - FOR SIGN UP 
Before running the app locally, configure the following services:

Stripe API Create an account at Stripe - stripe.com. 
Obtain your Stripe Secret Key and Publishable Key. For testing purpose, live on test mode, create two products ("basic", and "pro") in the Product Catalog. 
In your working environment, open the gem file and write this line; 
    gem "stripe" 
    bundle install 
You need to store the secret information, hence the need to install a gem called figaro, that allows you to save secret information in application.yml file 
    gem "figaro" 
    bundle install (it created the application.yml file) ignore the application.yml in gitignore (root directory)

Ignore application.yml file
/config/application.yml 

Populate the application.yml with stripe publishable keys; 
    Go to config/initializers
    Create a stripe.rb file,
        code -r config/initializers/stripe.rb (for windows) 
    write; 
    stripe_api_key = ENV["stripe_api_key"] 
    STRIPE_PUBLIC_KEY = ENV["stripe_publishable_key"]

AWS S3 FOR FILE STORAGE 
To successfully use AWS S3, you have to install the necessary gems and run the right migrations, to prepare your working environment for production deployment.
To use ActiveStorage, do the following; 
    gem "image_processing", ">=1.2" 
    bundle install 
In the terminal run; 
    rails active_storage:install (this creates a migration file) 
    rails db:migrate 
For development environment, update the development.rb and test.rb as follows respectively; 
    Config.active_storage.service = :local 
    Config.active_storage.service = :test 
TO USE AWS; 
Create an amazon aws account. 
Search for S3 and create a bucket with a bucket name of choice. 
Search for IAM and create users - (Select "AWS service", as trusted entity, for IAM choose EC2, permissions select "AmazonS3 FullAccess") - Save Create access key and save in a secure notepad. 
Install the following gem; 
    gem "aws-sdk-s3" 
    bundle install 
Update the config/storage.yml file 
    amazon: 
        service: S3 
        access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %> 
        secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %> 
        region: <%= ENV['AWS_REGION'] %> 
        bucket: <%= ENV['AWS_BUCKET_NAME'] %> 
In the config/production.rb
# Store files in AWS
    config.active_storage.service = :amazon # Use the 'amazon' service from storage.yml 
In config/initiliazers/aws.rb - 
    create an aws.rb
    code -r config/initializers/aws.rb;
    
    file require 'aws-sdk-s3'

    Aws.config.update({ 
        region: 'eu-north-1', 
        credentials: Aws::Credentials.new( 
            ENV['AWS_ACCESS_KEY_ID'], 
            ENV['AWS_SECRET_ACCESS_KEY'] ) 
    }) 
Linked successfully.

MAILGUN API FOR EMAIL NOTIFICATIONS
Create a Mailgun Account. 
Go to send - sending - domains - add authorized recipient email and confirm it Go to Domain settings - Sending API keys - then create a new key. 
Then update your production.rb for mailgun;
# Set host to be used by links generated in mailer templates.
    config.action_mailer.default_url_options = { host: "link to your website" }

# Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
# ActionMailer configuration for Mailgun
    config.action_mailer.delivery_method = :smtp 
    config.action_mailer.smtp_settings = { 
        address: 'smtp.mailgun.org', 
        port: 587, 
        domain: ENV["MAILGUN_DOMAIN"], # Replace with your Mailgun domain 
        user_name: ENV["MAILGUN_SMTP_USERNAME"], # Mailgun 
        SMTP login password: ENV["MAILGUN_SMTP_PASSWORD"], # Mailgun SMTP password 
        authentication: :plain, 
        enable_starttls_auto: true 
    } 
Save all these env in the application.yml file. 
Install; 
    gem "mailgun-ruby" 
    bundle install

RUNNING THE APPLICATION LOCALLY 
After configuring everything, you can start the Rails server: 
    bundle exec rails s 
    Visit http://localhost:3000 in your browser to view the app.

RUNNING THE TEST SUITE 
To ensure everything is working properly, run the test suite: Run all tests: 
    rails test 
You can also run tests for a specific model or controller, for example: 
    rails test test/models/user_test.rb

DEPLOYMENT INSTRUCTIONS (RENDER) 
To deploy DevConnect to Render, follow these steps:
Create a Render Account Sign up for a free account on Render.
Create a New Web Service Go to the Render Dashboard. Click New and select Web Service. Connect your GitHub repository for DevConnect. Choose the Ruby environment.
In your working environment, 
    create a render.yaml in the root directory, 
        code -r render.yaml
    configure like so; use the name of your app 
databases:
=======
**Table of Contents**
1. Introduction
2. Technologies Used
3. Features
4. Setup Instructions
5. Configuration
6. Running the Application Locally
7. Running the Test Suite
8. Deployment Instructions (Render)
9. Contributing
10. License

**Introduction**
DevConnect is a platform that allows users to build and manage their professional profiles with various access levels. It offers the following features:
* Secure authentication using Devise.
* Payment integration with Stripe to manage subscriptions.
* Image storage on AWS S3 using ActiveStorage.
* Email notifications powered by Mailgun.
* A responsive and modern UI built with Bootstrap.
Users can choose between two plans: a free basic plan with limited profile information visibility and a pro plan with full access to other users' contact details.

**Technologies Used**
1. Ruby on Rails (Back-end)
2. JavaScript (Front-end interactivity)
3. PostgreSQL (Database)
4. Devise (Authentication)
5. Stripe (Payment processing)
6. AWS S3 (File storage)
7. Mailgun (Email notifications)
8. Bootstrap (Responsive UI design)
9. RSpec (Testing)
10. Render (Deployment)

**Features**
* User Authentication: Secure user registration and login via Devise.
* Subscription Plans: Two user tiers: Basic (free) and Pro (paid via Stripe).
* File Uploads: Profile images stored using AWS S3 via ActiveStorage.
* Email Notifications: Contact us using Mailgun.
* Responsive UI: The app is mobile-friendly and adapts to various screen sizes using Bootstrap.
* User Profiles: Users can view and manage their profile details, which can be private or public depending on their subscription plan.

**Setup Instructions**
To get started with DevConnect on Windows, follow these steps to set up the development environment.

1. Install Prerequisites
Before installing Ruby on Rails, make sure you have Node.js and Yarn already installed on your computer. You can download them from the following links:
Node.js: Download Node.js
Yarn: Download Yarn

2. Install Ruby
Download Ruby from https://rubyinstaller.org/.
Run the installer and follow the prompts to install Ruby on your system.
After installation, open Command Prompt or your coding environment (e.g., VSCode), and verify the installation by running:
ruby -v
You should see something like:
ruby 3.3.6
This confirms that Ruby is correctly installed.

3. Install Rails
Once Ruby is installed, open Command Prompt or your coding environment terminal and run the following command to install Rails:
gem install rails
After installation is complete, verify that Rails was installed correctly by running:
rails -v
You should see:
Rails 8.0.1
This confirms that Rails has been installed successfully.

4. Set Up PostgreSQL
DevConnect uses PostgreSQL as its database. If you don't have PostgreSQL installed yet, you can download it from PostgreSQL Official Site - https://www.postgresql.org/download/windows/.
Follow these steps to set up PostgreSQL:
Download and install PostgreSQL from the link above.
During installation, make sure to take note of the password you set for the postgres user.
Once installed, verify PostgreSQL is working by opening the SQL Shell and running:
psql -U postgres
You'll be prompted for the password you set during installation.

5. Set Up Your Rails Project with PostgreSQL
Now that you have Ruby, Rails, and PostgreSQL installed, you can create a new Rails application with PostgreSQL as the database.
Open your terminal and run the following command:
rails new DevConnect --database=postgresql
This will create a new Rails application named DevConnect configured to use PostgreSQL as the database.

6. Configure Your Database
Once the Rails app has been created, navigate to the project directory:
cd DevConnect
Now, configure your database:
Open config/database.yml and ensure the development and test databases are set up with the correct username and password for PostgreSQL (the default is usually postgres).

Example:
development:
  <<: *default
  database: devconnect_development
  username: postgres
  password: your_postgresql_password

test:
  <<: *default
  database: devconnect_test
  username: postgres
  password: your_postgresql_password
  
Create the databases by running the following command:
rails db:create

Run the migrations:
rails db:migrate
Now, your database is set up and ready to go!

7. Install JavaScript Dependencies
DevConnect uses Yarn to manage JavaScript packages. To install all necessary JavaScript dependencies, run:
yarn install

9. Start the Rails Server
Finally, you can start the Rails server:
bundle exec rails s
Visit http://localhost:3000 in your browser to view the application.

**Configuration - For Sign Up**
Before running the app locally, configure the following services:
1. Stripe API
Create an account at Stripe - stripe.com.
Obtain your Stripe Secret Key and Publishable Key. For testing purpose, live on test mode, create two products ("basic", and "pro") in the Product Catalog.
In your working environment, open the gem file and write this line;
   gem "stripe"
   bundle install
You need to store the secret information, hence the need to install a gem called figaro, that allows you to save secret information in application.yml file
   gem "figaro"
   bundle install (it created the application.yml file)
   ignore the application.yml in gitignore (root directory)
   # Ignore application.yml file
   /config/application.yml
   populate the application.yml with stripe publishable keys
Go to config/initializers and create a stripe.rb file, write;
   stripe_api_key = ENV["stripe_api_key"]
   STRIPE_PUBLIC_KEY = ENV["stripe_publishable_key"]

2. AWS S3 for File Storage
To successfully use AWS S3, you have to install the necessary gems and run the right migrations, to prepare your working environment for production deployment
To use ActiveStorage, do the following;
  gem "image_processing", ">=1.2"
  bundle install
In the terminal run;
  rails active_storage:install (this creates a migration file)
  rails db:migrate
For development environment, update the development.rb and test.rb as follows respectively;
  Config.active_storage.service = :local
  Config.active_storage.service = :test
TO USE AWS;
Create an amazon aws account.
Search for S3 and create a bucket with a bucket name of choice.
Search for IAM and create users - (Select "AWS service", as trusted entity, for IAM choose EC2, permissions select "AmazonS3 FullAccess") - Save
Create access key and save in a secure notepad.
Install the following gem;
  gem "aws-sdk-s3"
  bundle install
Update the config/storage.yml file
  amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: <%= ENV['AWS_REGION'] %>
  bucket: <%= ENV['AWS_BUCKET_NAME'] %>
In the config/production.rb
   #  Store files in AWS
  config.active_storage.service = :amazon # Use the 'amazon' service from storage.yml
In config/initiliazers/aws.rb - create an aws.rb file
  require 'aws-sdk-s3'

  Aws.config.update({
    region: 'eu-north-1',
    credentials: Aws::Credentials.new(
      ENV['AWS_ACCESS_KEY_ID'], 
      ENV['AWS_SECRET_ACCESS_KEY']
    )
  })
Linked successfully.

3. Mailgun API for Email Notifications
Create a Mailgun Account.
Go to send - sending - domains - add authorized recipient email and confirm it
Go to Domain settings - Sending API keys - then create a new key. Then update your production.rb for mailgun;
 # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { host: "link to your website" }

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # ActionMailer configuration for Mailgun
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    port: 587,
    domain: ENV["MAILGUN_DOMAIN"],  # Replace with your Mailgun domain
    user_name: ENV["MAILGUN_SMTP_USERNAME"],  # Mailgun SMTP login
    password: ENV["MAILGUN_SMTP_PASSWORD"],  # Mailgun SMTP password
    authentication: :plain,
    enable_starttls_auto: true
  }
Save all these env in the application.yml file.
Install;
  gem "mailgun-ruby"
  bundle install

**Running the Application Locally**
After configuring everything, you can start the Rails server:
  bundle exec rails s
  Visit http://localhost:3000 in your browser to view the app.

**Running the Test Suite**
To ensure everything is working properly, run the test suite:
Run all tests:
  rails test
You can also run tests for a specific model or controller, for example:
  rails test test/models/user_test.rb
  
**Deployment Instructions (Render)**
To deploy DevConnect to Render, follow these steps:
1. Create a Render Account
    Sign up for a free account on Render.
2. Create a New Web Service
    Go to the Render Dashboard.
    Click New and select Web Service.
    Connect your GitHub repository for DevConnect.
    Choose the Ruby environment.
3. In your working environment, create a render.yaml in the root directory, configure like so; use the name of your app
   databases:
>>>>>>> 2c144bfb7f17927a92d67cb95777c66b9ca35206
  - name: DevConnect
    databaseName: devconnect
    user: devconnect
    plan: free

<<<<<<< HEAD
services:
=======
   services:
>>>>>>> 2c144bfb7f17927a92d67cb95777c66b9ca35206
  - type: web
    name: DevConnect
    runtime: ruby
    plan: free
    buildCommand: "./bin/render-build.sh && bundle exec rails db:migrate"
    # preDeployCommand: "bundle exec rails db:migrate" # preDeployCommand only available on paid instance types
    startCommand: "bundle exec rails server"
    envVars:
      - key: DATABASE_URL
        fromDatabase:
          name: DevConnect
          property: connectionString
      - key: RAILS_MASTER_KEY
        sync: false
      - key: WEB_CONCURRENCY
        value: 2 # sensible default
<<<<<<< HEAD

create a file in bin folder called render-build.sh #!/usr/bin/env bash
    code -r bin/render-build.sh
Configure as follows;
#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
#bundle exec rails db:seed
# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

# bundle exec rake db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1
# bundle exec rails db:migrate

After linking Github to render, we are setup to deploy our web app, click on blueprint and connect to the github folder, it will ask you for RAILS MASTER KEY Location - config/master.key - copy the whole numbers and paste and click on continue

Set Environment Variables Set the following environment variables on Render: 
    STRIPE_SECRET_KEY: Your Stripe Secret Key. 
    STRIPE_PUBLISHABLE_KEY: Your Stripe Publishable Key. 
    AWS_ACCESS_KEY_ID: Your AWS Access Key. 
    AWS_SECRET_ACCESS_KEY: Your AWS Secret Access Key. 
    MAILGUN_API_KEY: Your Mailgun API Key. 
    MAILGUN_DOMAIN: Your Mailgun Domain. 
You can set these environment variables under the Environment section in the Render service settings.

In the build command, add rails db:seed just in case there are unseeded file.

Ensure the production side of your database.yml is configured like so; 
    production:
=======
4. create a file in bin folder called render-build.sh
    #!/usr/bin/env bash
    # exit on error
    set -o errexit
    
    bundle install
    bundle exec rails assets:precompile
    bundle exec rails assets:clean
    #bundle exec rails db:seed
    # If you're using a Free instance type, you need to
    # perform database migrations in the build command.
    # Uncomment the following line:
    
    # bundle exec rake db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1
    # bundle exec rails db:migrate
5. After linking Github to render, we are setup to deploy our web app, click on blueprint and connect to the github folder, it will ask you for RAILS MASTER KEY
    Location - config/master.key - copy the whole numbers and paste and click on continue
6. Set Environment Variables
Set the following environment variables on Render:
    STRIPE_SECRET_KEY: Your Stripe Secret Key.
    STRIPE_PUBLISHABLE_KEY: Your Stripe Publishable Key.
    AWS_ACCESS_KEY_ID: Your AWS Access Key.
    AWS_SECRET_ACCESS_KEY: Your AWS Secret Access Key.
    MAILGUN_API_KEY: Your Mailgun API Key.
    MAILGUN_DOMAIN: Your Mailgun Domain.
You can set these environment variables under the Environment section in the Render service settings.
7. In the build command, add rails db:seed just in case there are unseeded file.
8. Ensure the production side of your database.yml is configured like so;
   production:
>>>>>>> 2c144bfb7f17927a92d67cb95777c66b9ca35206
  primary: &primary_production
    <<: *default
    database: dev_connect_production
    url: <%= ENV["DATABASE_URL"] %>
    password: <%= ENV["DEV_CONNECT_DATABASE_PASSWORD"] %>
  cache:
    <<: *primary_production
    database: dev_connect_production_cache
    migrations_paths: db/cache_migrate
  queue:
    <<: *primary_production
    database: dev_connect_production_queue
    migrations_paths: db/queue_migrate
  cable:
    <<: *primary_production
    database: dev_connect_production_cable
    migrations_paths: db/cable_migrate

<<<<<<< HEAD
Deploy the Application Once the environment variables are set, Render will automatically deploy the application for you. You can monitor the deployment progress on the Render Dashboard.

Access Your Live App Your app will be live at the URL provided by Render (e.g., https://devconnect.onrender.com).

CONTRIBUTIONS
Feel free to fork the repository, make changes, and submit pull requests. Please ensure that all code is well-documented and follows the project's coding style.

LICENSE
This project is licensed under the MIT License - see the LICENSE file for details.
=======
9. Deploy the Application
Once the environment variables are set, Render will automatically deploy the application for you. You can monitor the deployment progress on the Render Dashboard.

10. Access Your Live App
Your app will be live at the URL provided by Render (e.g., https://devconnect.onrender.com).

**Contributing**
Feel free to fork the repository, make changes, and submit pull requests. Please ensure that all code is well-documented and follows the project's coding style.

**License**
This project is licensed under the MIT License - see the LICENSE file for details.
>>>>>>> 2c144bfb7f17927a92d67cb95777c66b9ca35206
