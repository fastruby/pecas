class TimeEntry
  ##
  # Finds users from a messaginge service, entries for those users, and then
  #   forwards those users to maybe_message to run a ruleset and warn users of
  #   any issues
  #
  # Because this app will service users around the world we allow callers to pass
  #   an "actionable hour" - used to represent the hour to consider "end of day".
  #   When the service looks for users to send messages to - it limits results to
  #   those who are in a timezone where "now" is the actionable hour
  #
  # @param [String] group_handle The id of a group from a mesdsaging service: ex @ombuteam on Slack
  # @param [Time] date The date to retrieve time entries for
  # @param [Integer] actionable_hour The hour for the end of day on a 24 hours clock: ex 18 = 6 PM
  # @param [Class] messaging_service The message service used to find users and send information to them
  def self.alert_problematic_time_entries(group_handle, date, actionable_hour, messaging_service = SlackService::GroupMemberMessaging)
    service = messaging_service.new(group_handle, actionable_hour)
    entry_group = Entry.for_users_by_email(service.included_emails()).where(date: date).group_by(&:user_email)
    entry_group.each { |email, entries| maybe_message(email, entries, service) }
    :ok
  end

  ##
  # Checks time entries against a set of rules and forwards any which fails to .message
  #
  # @param [String] email
  # @param [Array<Entry>] entries
  # @param [Object] messaging_service ex: SlackService::GroupMemberMessaging
  # @params [Class] rule_handler The set of rules to use to validate time entries
  def self.maybe_message(email, entries, messaging_service, rule_handler = TimeEntry::DescriptionRules)
    service_user = messaging_service.user(email)
    dirty_entries = entries.select { |entry| not rule_handler.new(entry.description).valid? }
    unless dirty_entries.empty?
      message = bad_entry_message_template(service_user, dirty_entries)
      service_user.message(message)
    end
  end

  ##
  # The message the system should send if there are invalid time entries
  #
  # @param [Object] messaging_service_user ex: SlackService::SlackUser
  # @param [Array<Enbtry>]
  def self.bad_entry_message_template(messaging_service_user, entries)
    {
      text: "I found these entries that might need a better description",
      blocks: [
        {
          "type": "section",
          "text": {
            "type": "plain_text", 
            "text": "Hi #{messaging_service_user.first_name}, I found these entries that might " +
            "need a better description - possibly a missing a JIRA ticket or ID:"
          }
        },
        {
          "type": "section",
          "text": {
            "type": "mrkdwn", 
            "text": entries.map{|entry| "- #{entry.description} (#{entry.length})" }.join("\n")
          }
        },
        {
          "type": "section",
          "text": {
            "type": "plain_text", 
            "text": "Please make sure that these entries are accurate. If they " +
            "are all good, great! If not, please make sure you fix them so you " +
            "don't get penalized for any of them!"
          }
        },
      ]
    }
  end
end
