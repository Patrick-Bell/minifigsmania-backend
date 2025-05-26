class SessionsController < ApplicationController
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
        secure: Rails.env.production?,
        same_site: :none,
        expires: 2.hours.from_now,
        path: "/"
      }
      cookie_options[:domain] = ".minifigsmania.netlify.app" if Rails.env.production?

      cookies[:token] = cookie_options

      render json: {
        message: 'Login successful',
        user: user,
        exp: 2.hours.from_now,
        token: token
      }
    else
      render json: { error: 'Invalid Password' }, status: :unauthorized
    end
  end

  def destroy
    cookie_options = {
      path: "/"
    }
    cookie_options[:domain] = ".minifigsmania.netlify.app" if Rails.env.production?

    cookies.delete(:token, cookie_options)

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
