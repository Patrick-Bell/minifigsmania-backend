class SessionsController < ApplicationController


    include ActionController::Cookies
    JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']


    def create
        user = User.find_by(email: params[:user][:email])

        if user.nil?
          render json: { error: 'Incorrect Email' }, status: :unauthorized
          return
        end
    
        if user&.authenticate(params[:user][:password]) # NOT authenticate?
          token = JWT.encode({ user_id: user.id, email: user.email, exp: 1.hour.from_now.to_i }, JWT_SECRET_KEY, 'HS256')
    
          Rails.logger.debug "Generated Token: #{token}"
    
          cookies[:token] = {
            value: token,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :none,
            expires: 1.hour.from_now,
            domain: '.minifigsmania.netlify.app'
          }
    
          render json: { message: 'Login successful', user: user, exp: 1.hour.from_now, token: token }
        else
          render json: { error: 'Invalid Password' }, status: :unauthorized
        end
      end

      def destroy
        cookies.delete(:token,
          domain: '.minifigsmania.netlify.app',
          path: '/',
          secure: Rails.env.production?,
          same_site: :none,
          httponly: true,
          expires: 1.hour.ago
        )
        render json: { message: 'Logout successful' }
      end
      


      def generate_jwt_token(user)
        JWT.encode({ user_id: user.id, email: user.email, exp: 1.hour.from_now.to_i }, JWT_SECRET_KEY, 'HS256')
      end



     
end
