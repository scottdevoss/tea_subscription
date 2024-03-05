class Api::V1::SubscriptionsController < ApplicationController

  def index
    render json: SubscriptionSerializer.new(Subscription.all)
  end 

  def create
    new_subscription = Subscription.new(subscription_params)
    if new_subscription.save
      render json: SubscriptionSerializer.new(new_subscription), status: :created
    else
      render json: { errors: {title: 'Please fill in all fields', status: "400"}}, status: :bad_request
    end
  end

  def update
    subscription = Subscription.find(params[:id])
    if params.key?(:status)
      subscription.update(update_params)
      render json: SubscriptionSerializer.new(subscription), status: :ok
    else
      render json: { errors: {title: 'Only status can be updated', status: "422"} }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :tea_id, :customer_id)
  end

  def update_params
    params.require(:subscription).permit(:status)
  end
end