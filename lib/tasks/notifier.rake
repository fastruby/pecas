namespace :notify do
  desc "Sends Slack warnings to users which have poorly-formed noko time entries"
  task :send_noko_format_warning, [:group_handle] => ['import:entries'] do |t, args|
    raise "You must pass a Slack Handle for the group you'd like to message" unless args.group_handle

    # Eight pm is 20:00 on a 24 hour clock. This will be used to define "end of day"
    eight_pm_hour = 20
    p "Assessing time entries to send validation warnings if needed"
    TimeEntry.alert_problematic_time_entries(args.group_handle, Date.new(2022, 2, 27), 3, SlackService::GroupMemberMessaging)
    p "Finished assessing"
  end
end
