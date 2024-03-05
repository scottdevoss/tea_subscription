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
      
      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }
      
      post "/api/v1/subscriptions", headers: headers, params: subscription.to_json

      expect(response.status).to eq(201)
  
      json = JSON.parse(response.body, symbolize_names: true) 
      
      expect(json).to have_key(:data)
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)

      expect(json[:data][:attributes]).to have_key(:title)
      expect(json[:data][:attributes]).to have_key(:price)
      expect(json[:data][:attributes]).to have_key(:status)
      expect(json[:data][:attributes]).to have_key(:frequency)
      expect(json[:data][:attributes]).to have_key(:tea_id)
      expect(json[:data][:attributes]).to have_key(:customer_id)
    end

    #Sad Path Subscribing
    it "gives an error if not all fields are filled in" do

      customer = Customer.create!(first_name: "Jack", last_name: "Sparrow", email: "jack@pirate.com", address: "30 Black Pearl Street")
      tea = Tea.create!(title: "Chai", description: "Sweet and Spicy", temperature: 150, brew_time: "10 minutes")
      
      subscription = {
        title: "Tea Subscription",
        price: 10,
        status: 1,
        frequency: "",
        tea_id: tea.id,
        customer_id: ""
      }
      
      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }
      
      post "/api/v1/subscriptions", headers: headers, params: subscription.to_json

      expect(response.status).to eq(400)
  
      json = JSON.parse(response.body, symbolize_names: true) 
      
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_a(Hash)
      expect(json[:errors]).to have_key(:title)
      expect(json[:errors]).to have_key(:status)
      expect(json[:errors][:title]).to eq("Please fill in all fields")
    end

    #PATCH /api/v1/subscriptions/subscription_id
    it "updates/cancels a customers subscription" do
      customer = Customer.create!(first_name: "Jack", last_name: "Sparrow", email: "jack@pirate.com", address: "30 Black Pearl Street")
      tea = Tea.create!(title: "Chai", description: "Sweet and Spicy", temperature: 150, brew_time: "10 minutes")
      subscription = Subscription.create!(title: "Subscription", price: 10, status: 1, frequency: "weekly", tea_id: tea.id, customer_id: customer.id)
    
      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }

      sub_params = { status: 0 }
      
      patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: sub_params.to_json

      expect(response.status).to eq(200)
  
      json = JSON.parse(response.body, symbolize_names: true) 

      expect(json).to have_key(:data)
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)

      expect(json[:data][:attributes]).to have_key(:title)
      expect(json[:data][:attributes]).to have_key(:price)
      expect(json[:data][:attributes]).to have_key(:status)
      expect(json[:data][:attributes]).to have_key(:frequency)
      expect(json[:data][:attributes]).to have_key(:tea_id)
      expect(json[:data][:attributes]).to have_key(:customer_id)

      expect(json[:data][:attributes][:status]).to eq("cancelled")
    end

    #Sad Path updated subscription
    it "gives an error if the customer tries to update something other than the status" do
      customer = Customer.create!(first_name: "Jack", last_name: "Sparrow", email: "jack@pirate.com", address: "30 Black Pearl Street")
      tea = Tea.create!(title: "Chai", description: "Sweet and Spicy", temperature: 150, brew_time: "10 minutes")
      subscription = Subscription.create!(title: "Subscription", price: 10, status: 1, frequency: "weekly", tea_id: tea.id, customer_id: customer.id)
    
      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }

      sub_params = { price: 0 }
      
      patch "/api/v1/subscriptions/#{subscription.id}", headers: headers, params: sub_params.to_json

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)

      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_a(Hash)
      expect(json[:errors]).to have_key(:title)
      expect(json[:errors]).to have_key(:status)
      expect(json[:errors][:title]).to eq("Only status can be updated")
    end


    #GET /api/v1/subscriptions
    it "shows all the customers subscriptions (active and canceled)" do
      customer = Customer.create!(first_name: "Jack", last_name: "Sparrow", email: "jack@pirate.com", address: "30 Black Pearl Street")
      tea = Tea.create!(title: "Chai", description: "Sweet and Spicy", temperature: 150, brew_time: "10 minutes")
      tea2 = Tea.create!(title: "Hibiscus", description: "Fruity", temperature: 200, brew_time: "5 minutes")
      subscription = Subscription.create!(title: "Subscription", price: 10, status: 1, frequency: "weekly", tea_id: tea.id, customer_id: customer.id)
      subscription2 = Subscription.create!(title: "Subscription 2", price: 15, status: 0, frequency: "monthly", tea_id: tea2.id, customer_id: customer.id)

      get "/api/v1/subscriptions"

      expect(response.status).to eq(200)
  
      json = JSON.parse(response.body, symbolize_names: true) 

      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Array)
      expect(json[:data][0][:attributes][:status]).to eq("active")
      expect(json[:data][1][:attributes][:status]).to eq("cancelled")
    end
  end
end