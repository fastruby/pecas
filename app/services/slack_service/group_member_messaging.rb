class SlackService::GroupMemberMessaging
  attr_reader :members

  ##
  # @param [String] group_handle The id of a group from a mesdsaging service: ex @ombuteam on Slack
  # @param [Integer] actionable_hour The hour for the end of day on a 24 hours clock: ex 18 = 6 PM
  # @param [Time] now The current system time
  def initialize(group_handle, actionable_hour, now = Time.now)
    connect_client
    set_usergroup_id(group_handle)
    set_user_ids
    set_members(actionable_hour, now)
  end

  def included_emails
    @members.keys
  end

  def send_time_entry_format_warning(email, entries)
    return :ok if entries.empty?

    member = @members[email]
    message = time_entry_format_warning_message(member, entries)
    member.message(message)

    :ok
  end

    private

    def connect_client
      @client = Slack::Web::Client.new
      raise "Slack API connection failed" if @client.auth_test[:team_id].nil?
    end

    def set_members(actionable_hour, now)
      @members = @user_ids.inject({}) do |users, user_id|
        result, data = ::SlackService.find_slack_user(user_id, @client)

        raise data unless result == :ok

        if now.in_time_zone(data.tz).hour == actionable_hour
          users[data.email] = data
        end
        
        users
      end
    end

    def set_user_ids
      result, data = ::SlackService.find_usergroup_user_ids(@usergroup_id, @client)
      raise data unless result == :ok

      @user_ids = data
    end

    def set_usergroup_id(group_handle)
      result, data = ::SlackService.find_usergroup_id(group_handle, @client)
      raise data unless result == :ok

      @usergroup_id = data
    end

    def time_entry_format_warning_message(member, entries)
      {
        text: "I found these entries that might need a better description",
        blocks: [
          {
            "type": "section",
            "text": { "type": "plain_text", "text": time_entry_format_warning_prefix(member) }
          },
          {
            "type": "section",
            "text": { "type": "mrkdwn", "text": entries.map{|entry| "* #{entry.description} (#{entry.length})" }.join("\n") }
          },
          {
            "type": "section",
            "text": { "type": "plain_text", "text": time_entry_format_warning_suffix }
          },
        ]
      }
    end

    def time_entry_format_warning_prefix(member)
      "Hi #{member.first_name}, I found these entries that might " +
      "need a better description - possibly a missing a JIRA ticket or ID:"
    end

    def time_entry_format_warning_suffix
      "Please make sure that these entries are accurate. If they " +
      "are all good, great! If not, please make sure you fix them so you " +
      "don't get penalized for any of them!"
    end
end
