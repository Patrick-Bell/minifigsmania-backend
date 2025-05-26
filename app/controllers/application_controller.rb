class ApplicationController < ActionController::API
    
    include ActionController::Cookies
    before_action :set_current_user
  
    def set_current_user
      @current_user = decode_token
    end
  
    def current_user
      if @current_user
        render json: { user: @current_user } # ✅ Return full user data
      else
        render json: { error: "Not logged in" }, status: :unauthorized
      end
    end

    def authorize_user
      unless @current_user && @current_user.role == 'user'
        render json: { error: "Access denied" }, status: :forbidden
      end
    end
  
    # ✅ Use this in controllers that require admin access
    def authorize_admin
      unless @current_user && @current_user.role == 'admin'
        render json: { error: "Admin access only" }, status: :forbidden
      end
    end

    def authorize_user_or_admin
      unless @current_user.present?
        render json: { error: "Not authorized" }, status: :unauthorized
      end
    end
  
    private
  
    def decode_token
      token = cookies[:token] # ✅ Ensure you access the correct cookie key
      return nil if token.blank?
  
      begin
        decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['user_id']
        User.find_by(id: user_id) # ✅ Use `find_by` to avoid crashes if user is deleted
      rescue JWT::DecodeError => e
        Rails.logger.warn "JWT Decode Error: #{e.message}" # ✅ Log errors for debugging
        nil
      end
    end
    
  end
  