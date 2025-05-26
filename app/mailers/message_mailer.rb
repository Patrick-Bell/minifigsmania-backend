class MessageMailer < ApplicationMailer

    def new_message(message)

        @message = message

        mail(to: ENV['EMAIL'], subject: "MinifigsMania | New Message")

    end
end
