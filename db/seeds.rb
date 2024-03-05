# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

customer = Customer.create!(first_name: "Jack", last_name: "Sparrow", email: "jack@pirate.com", address: "30 Black Pearl Street")
tea = Tea.create!(title: "Chai", description: "Sweet and Spicy", temperature: 150, brew_time: "10 minutes")
      
subscription = {
  title: "Tea Subscription",
  price: 10,
  status: 1,
  frequency: "weekly",
  tea_id: tea.id,
  customer_id: customer.id
}
