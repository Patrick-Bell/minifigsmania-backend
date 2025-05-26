class UserMailer < ApplicationMailer

    def welcome_email(user)

        @user = user

        mail(to: @user.email, subject: 'Welcome to MinifigsMania!')

    end


    def new_user_admin(user)

        @user = user

        mail(to: ENV['EMAIL'], subject: 'MinifigsMania | New User')

    end

    def reset_password_email
        @user = params[:user]
        @reset_url = "http://localhost:5173/reset-password?token=#{@user.reset_password_token}"
    
        mail(to: @user.email, subject: "Reset your password | MinifigsMania")
    end

    def reset_password_success_email
        @user = params[:user]
    
        mail(to: @user.email, subject: "Your password has been reset | MinifigsMania")
    end


end
