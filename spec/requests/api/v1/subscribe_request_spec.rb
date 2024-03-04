require "rails_helper"

RSpec.describe "Tea Subscriptions", type: :request do
  describe "Subscriptions" do
    #POST /api/v1/subscriptions
    it "subscribes a customer to a tea subscription" do

      headers = { "CONTENT_TYPE" => "application/json",
        "ACCEPT" => "application/json"
      }

      post "/api/v1/subscriptions", headers: headers, params: 
    end
  end
end