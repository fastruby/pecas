class TimeEntry
  attr_reader :grouped_entries

  ##
  # @params [Object] messaging_service Required service ex: SlackService::GroupMemberMessaging
  # @params [Object] rule_handler Required ruleset ex: TimeEntry::DescriptionRules
  # @option [Date] today Required date to retrieve time entries for
  # @option [Integer] hour_of_day Optional hour to run alerts on a 24 hour clock (13 = 1pm)
  def initialize(today, messaging_service, rule_handler, opts)
    @messaging_service = messaging_service
    @rule_handler = rule_handler
    @today = today
    @hour_to_run = opts[:hour_of_day]
  end
  ##
  # Collects time entries for members of a given message service group and sends
  #   validation alerts if required
  #
  # @param [String] group_handle The id of a group from a messaging service: ex `ombuteam` on Slack
  def invalid_time_entries_alert(group_handle)
    set_messaging_service(group_handle)
    set_grouped_entries

    @grouped_entries.each { |email, entries| maybe_message(email, entries) }
    :ok
  end

    private

    def maybe_message(email, entries)
      dirty_entries = entries.select { |entry|
        !@rule_handler.new(entry).valid?
      }

      unless dirty_entries.empty?
        @service.send_time_entry_format_warning(email, dirty_entries)
      end
    end

    def set_grouped_entries
      @grouped_entries = Entry
        .for_users_by_email(emails_to_consider)
        .where(date: @today)
        .group_by(&:user_email)
    end

    def set_messaging_service(group_handle)
      @service = @messaging_service.new(group_handle, @hour_to_run)
    end

    def emails_to_consider
      @service.included_emails
    end
end
