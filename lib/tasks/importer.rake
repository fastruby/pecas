require "freckle"

namespace :import do

  def freckle_client
    @freckle_client ||= Freckle::Client.new(token: ENV["FRECKLE_TOKEN"])
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
  task entries: [:users, :projects] do
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date

    puts "start importing entries from #{start_date} to #{end_date}"

    # TODO: This can only return a max of 30 entries, but it should actually
    # loop through all available pages for the given dates.
    result = freckle_client.get_entries(from: start_date, to: end_date)
    result.each do |entry|
      e1 = Entry.find_or_create_by(id: entry.id)
      e1.update_columns(
        description: entry.description,
        minutes:     entry.minutes,
        date:        entry.date,
        user_id:     entry.user_id,
        project_id:  entry.project_id
      )
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
