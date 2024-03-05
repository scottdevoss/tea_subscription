class Api::V1::SubscriptionsController < ApplicationController
  def create
    new_subscription = Subscription.new(subscription_params)
    if new_subscription.save
    
    else
      render json: { errors: [title: 'Please fill in all fields', status: "400"]}, status: :bad_request
    end
    
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id, :customer_id)
  end
end