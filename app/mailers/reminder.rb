class Reminder < ApplicationMailer
  default from: "ernesto@ombushop.com"

  def send_to(user)
    @user = user
    @url = "http://#{ENV['FRECKLE_ACCOUNT_HOST']}.letsfreckle.com"

    mail(to: @user.email, subject: 'Freckle Reminder')
  end
end
