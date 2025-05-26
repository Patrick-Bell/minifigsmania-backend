class UsersController < ApplicationController
  before_action :set_current_user, only: [:update]

  include ActionController::Cookies
  JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']


    def index
        @users = User.includes(orders: :line_items).all
        render json: @users, include: { orders: { include: :line_items } }, status: :ok
      end

      def update
        if @current_user.update(user_params)
          token = generate_jwt_token(@current_user)
          cookies[:token] = {
            value: token,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :none,  # Adjust if needed
            expires: 1.hour.from_now,
          }
          render json: @current_user, status: :ok
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      def show
        @user = User.find(params[:id])
        render json: @user, include: {
          orders: { include: :line_items },
          product_wishlists: { include: :product }
        }, status: :ok
      end


      def generate_jwt_token(user)
        JWT.encode({ user_id: user.id, email: user.email, exp: 1.hour.from_now.to_i }, JWT_SECRET_KEY, 'HS256')
      end
  

      def user_params
        params.require(:user).permit(:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :password_digest, :role, :address_line_1, :address_line_2, :city, :state, :postal_code, :country, :phone_number, :order_notifications, :promotion_notifications, :new_product_notifications, :newsletter_notifications)
      end
      

    
      
end
