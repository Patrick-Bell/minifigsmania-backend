class RegistrationsController < ApplicationController
  
   
  def create
    @user = User.new(sign_up_params)

    existing_user = User.find_by(email: @user.email)

    if existing_user
      render json: { error: 'Email already exists' }, status: :unprocessable_entity
      return
    end

    if @user.save
      UserMailer.new_user_admin(@user).deliver_now
      UserMailer.welcome_email(@user).deliver_now
      render json: { message: 'User registered successfully', user: @user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end

  