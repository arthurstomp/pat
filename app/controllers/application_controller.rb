class ApplicationController < ActionController::Base
  # Render front-end app to browser clients
  def root
    @title = 'Test'
  end

  def current_user
    @current_user ||= jwt_user
  end

  def authenticate
    if jwt_user
      jwt_user
    else
      render json: :unauthorized, status: 401
    end
  end

  def jwt_user
    return @jwt_user if @jwt_user
    return nil unless request.headers["authorization"]
    jwt = request.headers["authorization"].split[1]
    claims = JWT.decode jwt,
      Pat::Application.config.jwt_auth[:secret],
      true,
      {algorithm: Pat::Application.config.jwt_auth[:alg]}
    payload = claims[0]
    @jwt_user = User.find_by email: payload["email"]
  end
end
