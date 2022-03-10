namespace :notify do
  desc "Sends Slack warnings to users which have poorly-formed noko time entries"
  task :send_noko_format_warning, [:group_handle, :end_of_day] => ['import:entries'] do |t, args|
    raise "You must pass a Slack Handle for the group you'd like to message" unless args.group_handle

    # Eight pm is 20:00 on a 24 hour clock. This will be used to define "end of day"
    eight_pm_hour = 20

    p "Assessing time entries to send validation warnings if needed"
    p args.group_handle
    service = TimeEntry.new(Date.today, SlackService::GroupMemberMessaging, TimeEntry::DescriptionRules, hour_of_day: eight_pm_hour)
    service.invalid_time_entries_alert(args.group_handle)

    p "Messages sent"
  end
end
