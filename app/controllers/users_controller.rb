class UsersController < ApplicationController
  wrap_parameters format: [:json]
  include Pundit
  before_action :authenticate, except: :login
  after_action :verify_authorized

  # OK
  # Login or create
  def login
    user = User.find_by(email: user_params[:email],
                        username: user_params[:username])
    user = User.create user_params unless user
    authorize user
    if user and user.valid?
      render json: user.request_builder.to_build_for.target!
    else
      render json: user.errors.full_messages, status: 400
    end
  end

  def show
    authorize current_user
    render json: current_user.request_builder.to_build_for.target!,
      status: 200
  end

  # OK
  def update
    filtered_user_params = user_params.delete_if do |k,v|
      v == nil || v.empty?
    end
    authorize current_user
    if current_user.update(filtered_user_params)
      render json: current_user.request_builder.to_build_for.target!
    else
      render json: current_user.errors.full_messages, status: 400
    end
  end

  def delete
    authorize current_user
    current_user.destroy
    render :nothing, status: 204
  end

  private
  
  def user_params
    params.require(:user).permit(:email, :username)
  end
end
