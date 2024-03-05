require "rails_helper"

RSpec.describe "Tea Subscriptions", type: :request do
  describe "Subscriptions" do
    #POST /api/v1/subscriptions
    it "subscribes a customer to a tea subscription" do

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
      # require 'pry'; binding.pry

      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }

      post "/api/v1/subscriptions", headers: headers, params: subscription.to_json
    end
  end
end