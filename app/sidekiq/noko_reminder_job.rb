class NokoReminderJob
  include Sidekiq::Job

  def perform(msg_data)
    SlackService.send_message(
      msg_data[:slack_id],
      msg_data[:message],
      Slack::Web::Client.new
    )
  end
end
