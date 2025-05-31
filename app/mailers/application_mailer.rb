class ApplicationMailer < ActionMailer::Base
  default from: ENV['MINIFIGSMANIA_EMAIL']
  layout "mailer"
end
