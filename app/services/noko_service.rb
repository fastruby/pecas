require 'noko'

class NokoService

  def self.client
    @client ||= Noko::Client.new(token: ENV["NOKO_TOKEN"])
  end

  def self.import_users(page = 0)
    results = client.get_users(page: page)
    results.each do |user|
      u = User.find_or_create_by(id: user.id)
      u.update_attributes(name: "#{user.first_name} #{user.last_name}",
                          email: user.email, state: user.state)
    end

    import_users(page + 1) if results.try(:link).try(:next)
  end

  def self.import_projects(page = 0)
    results = client.get_projects(page: page)

    results.each do |project|
      p1 = Project.find_or_create_by(id: project.id)
      p1.update_attributes(name: project.name, enabled: project.enabled)
    end

    import_projects(page + 1) if results.try(:link).try(:next)
  end

  def self.import_entries(start_date, end_date, page = 0)
    results = client.get_entries(from: start_date, to: end_date, page: page)
    save_entries_for(results)

    import_entries(start_date, end_date, page + 1) if results.try(:link).try(:next)
  end

  def self.noko_send_missing_hours_reminder(messaging_service: nil)
    users_to_notify = User.includes(:entries).with_missing_hours_notification_enabled

    today = Date.today
    weekday = today.strftime("%A")
    start_date = (today - today.wday).to_datetime
    target_hours = today.wday() < 5 ? (today.wday * 8) : 40

    message = "Hello <@#{user.slack_id}>!\nIt's #{weekday}! By now, you should have logged a total of #{target_hours} hours to be on track for a regular 40-hour week.\
        \n\n*So far, you have logged #{total} hours.*\n\nCheers!"

    users_to_notify.each do |user|
      entries_minutes = user.entries.where(where(entries: {date: start_date..today})).sum(:minutes) 

      hours =  entries_minutes / 60
      minutes = entries_minutes % 60

      NokoReminderJob.perfom(slack_id: user.slack_id, message: message)
    end
  end

  private

  def self.save_entries_for(result)
    result.each do |entry|
      next if entry.project.nil?
      e1 = Entry.find_or_create_by(id: entry.id)
      e1.update_columns(
        description: entry.description,
        minutes:     entry.minutes,
        date:        entry.date,
        user_id:     entry.user.id,
        project_id:  entry.project.id
      )
    end
  end
end
