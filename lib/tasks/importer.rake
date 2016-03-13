require "freckle"

namespace :import do

  def freckle_client
    @freckle_client ||= Freckle::Client.new(token: ENV["FRECKLE_TOKEN"])
  end

  def save_entries_for(result)
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

  task users: :environment do
    freckle_client.get_users.each do |user|
      u = User.find_or_create_by(id: user.id)
      u.update_columns(name: "#{user.first_name} #{user.last_name}",
                       email: user.email)
    end
  end

  task projects: :environment do
    freckle_client.get_projects.each do |project|
      p1 = Project.find_or_create_by(id: project.id)
      p1.update_columns(name: project.name)
    end
  end

  desc "Import new Freckle entries"
  task entries: [:projects, :environment] do
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date

    puts "start importing entries from #{start_date} to #{end_date}"

    result = freckle_client.get_entries(from: start_date, to: end_date)
    save_entries_for(result)

    if result.try(:last_page)
      last_page = result.last_page.match(/page=(\d+)/)[1].to_i
      [1..last_page].each do |page|
        result = freckle_client.get_entries(from: start_date, to: end_date,
                                            page: page)
        save_entries_for(result)
      end
    end

    puts 'finished importing entries'
  end
end

namespace :calc do
  desc "Calculate Leaderboards"
  task leaderboards: :environment do
    ProjectLeaderboard.calculate
    UserLeaderboard.calculate
  end
end
