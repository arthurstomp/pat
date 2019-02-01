class UsersController < ApplicationController
  include Pundit
  before_action :authenticate, expect: :create
  after_action :verify_authorized

  def show
    render json: current_user.to_builder, status: 200
  end

  def create
    user = User.new user_params
    if user.save
      render json: user.to_builder
    else
      render json: {errors: current_user.errors}, status: 400
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user.to_builder
    else
      render json: {errors: current_user.errors}, status: 400
    end
  end

  def delete
    current_user.destroy
    render :nothing, status: 204
  end

  private
  
  def user_params
    params.require(:user).permit(:email, :username)
  end
end
