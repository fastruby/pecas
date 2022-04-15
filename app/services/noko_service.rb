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
