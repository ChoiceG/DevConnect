# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create the basic plan with id 1 if it doesn't exist
Plan.create!(id: 1, name: 'basic', price: 0.0)

# Create the pro plan with id 2 if it doesn't exist
Plan.create!(id: 2, name: 'pro', price: 10.0)