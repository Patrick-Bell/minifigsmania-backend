class PasswordsController < ApplicationController
    before_action :find_user_by_token, only: [:change_password]
    before_action :set_current_user, only: [:reset_password]
  
    # Forgot password action
    def forgot_password
        user = User.find_by(email: params[:email])

      
        # Check if a reset email has been sent within the last 10 minutes
        if user && user.reset_password_sent_at && user.reset_password_sent_at > 10.minutes.ago
          return render json: { error: 'A reset email has already been sent. Please check your inbox or try again later' }, status: :unprocessable_entity
        end
      
        # If the user exists, generate the password reset token and send the email
        if user
          user.generate_password_reset_token!
          UserMailer.with(user: user).reset_password_email.deliver_later
        end
      
        # Always return success regardless, to prevent email fishing
        render json: { message: "If your email is in our system, you'll receive reset instructions shortly." }, status: :ok
      end
      
  
    # Update password action when the user isnt signed in, forgot password route
    def change_password
      # Check if the token is expired
      if @user.password_reset_token_expired?
        invalidate_reset_token
        return render json: { error: "Token has expired" }, status: :unprocessable_entity
      end
  
      if @user.update(password_params)
        # Invalidate the reset token after successful password update
        invalidate_reset_token
        UserMailer.with(user: @user).reset_password_success_email.deliver_later
        render json: { message: "Password updated successfully" }, status: :ok
      else
        render json: { error: 'No'}, status: :unprocessable_entity
      end
    end

    def validate_reset_token
      @user = User.find_by(reset_password_token: params[:token])
  
      if @user && !@user.password_reset_token_expired?
        render json: { message: "Token is valid" }, status: :ok
      else
        render json: { error: "Invalid or expired token" }, status: :unprocessable_entity
      end
    end


    # route to change password, when user is already signed on
    def reset_password
      current_password = params[:password][:current]
      new_password = params[:password][:new]
      confirm_password = params[:password][:confirm]
    
      # Check if current password is correct
      unless @current_user.authenticate(current_password)
        return render json: { error: "Current password is incorrect" }, status: :unauthorized
      end
    
      # Check if new and confirm match
      if new_password != confirm_password
        return render json: { error: "New password and confirmation do not match" }, status: :unprocessable_entity
      end
    
      # Check if new password is the same as the old one
      if @current_user.authenticate(new_password)
        return render json: { error: "New password cannot be the same as the old password" }, status: :unprocessable_entity
      end
    
      # Attempt update
      if @current_user.update(password: new_password)
        render json: { message: "Password updated successfully" }, status: :ok
      else
        render json: { error: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    


  
    private
  
    # Find the user by the reset password token
    def find_user_by_token
      @user = User.find_by(reset_password_token: params[:token])
      unless @user
        render json: { error: "Invalid or expired token" }, status: :unprocessable_entity
      end
    end
    
  
    # Invalidate the reset token and reset the sent timestamp to prevent reuse
    def invalidate_reset_token
      @user.update!(
        reset_password_token: nil,
        reset_password_sent_at: nil
      )
    end
  
    # Strong parameters for password update
    def password_params
      params.permit(:password, :password_confirmation)
    end
  end
  