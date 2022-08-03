class NokoController < ApplicationController
  protect_from_forgery with: :null_session

  def subscribe
    user = User.where(["lower(name) LIKE ?", "%#{params["user_name"].downcase}%"]).first
    response_message = "You are already subscribed to the Noko Reminder :llama-yay:" 

    unless user.missing_hours_notification_enabled
      response_message = "You have been subscribed to a Noko time tracking reminder on Fridays :10_10:"
      slack_id = params["user_id"]
      user.update!(slack_id: slack_id, missing_hours_notification_enabled: true)
    end

    render plain: response_message, status: 200
  end
  
  def unsubscribe
    user = User.where(["lower(name) LIKE ?", "%#{params["user_name"].downcase}%"]).first
    response_message = "Im watching you, Wazowski! always watching. :roz:"

    if user.missing_hours_notification_enabled
      response_message = "You are no longer subscribed to the Noko Reminder :squirrel:" 
      user.update!(missing_hours_notification_enabled: false)
    end

    render plain: response_message, status: 200
  end
end
