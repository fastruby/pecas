require 'noko'

class NokoService

  def self.client
    @client ||= Noko::Client.new(token: ENV["NOKO_TOKEN"])
  end

  def self.import_users
    client.get_users.each do |user|
      u = User.find_or_create_by(id: user.id)
      u.update_attributes(name: "#{user.first_name} #{user.last_name}",
                          email: user.email, state: user.state)
    end
  end

  def self.import_projects
    client.get_projects.each do |project|
      p1 = Project.find_or_create_by(id: project.id)
      p1.update_attributes(name: project.name, enabled: project.enabled)
    end
  end

  def self.import_entries(start_date, end_date)
    result = client.get_entries(from: start_date, to: end_date)
    save_entries_for(result)

    if last = result.try(:link).try(:last)
      last_page = last.match(/page=(\d+)/)[1].to_i
      (2..last_page).each do |page|
        result = client.get_entries(from: start_date, to: end_date, page: page)
        save_entries_for(result)
      end
    end
  end

  private

  def self.save_entries_for(result)
    result.each do |entry|
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
