class MessageMailer < ApplicationMailer

    def new_message(message)

        @message = message

        mail(to: ENV['MINIFIGSMANIA_EMAIL'], subject: "MinifigsMania | New Message")

    end
end
