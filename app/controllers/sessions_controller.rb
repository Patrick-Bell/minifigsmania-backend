class SessionsController < ApplicationController
  require 'jwt'

  # Include cookies functionality for setting and deleting cookies
  include ActionController::Cookies
  JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']

  def create
    user = User.find_by(email: params[:user][:email])

    if user.nil?
      render json: { error: 'Incorrect Email' }, status: :unauthorized
      return
    end

    if user&.authenticate(params[:user][:password])
      token = JWT.encode({ user_id: user.id, email: user.email, exp: 2.hours.from_now.to_i }, JWT_SECRET_KEY, 'HS256')

      Rails.logger.debug "Generated Token: #{token}"

      cookie_options = {
      value: token,
      httponly: true,
      expires: 2.hours.from_now,
      same_site: Rails.env.production? ? :none : :lax,
      secure: Rails.env.production?,
      domain: 'minifigsmania-backend-fce4e488a52a.herokuapp.com', # ✅ exact match
      path: '/'
    }
    cookies[:token] = cookie_options



      render json: {
        message: 'Login successful',
        user: user,
        exp: 2.hours.from_now,
        token: token,
      }
    else
      render json: { error: 'Invalid Password' }, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:token,
    domain: 'minifigsmania-backend-fce4e488a52a.herokuapp.com', # ✅ exact match
    secure: Rails.env.production?,
    same_site: Rails.env.production? ? :none : :lax,
    httponly: true,
    path: '/'
)
    render json: { message: 'Logout successful' }
  end
  
  
  

  def generate_jwt_token(user)
    JWT.encode(
      { user_id: user.id, email: user.email, exp: 2.hours.from_now.to_i },
      JWT_SECRET_KEY,
      'HS256'
    )
  end
end
