require 'byebug'

namespace :import do

  task users: :environment do
    LetsFreckle::User.all.each do |user|
      u = User.find_or_create_by(id: user.id)
      u.update_columns(name: "#{user.first_name} #{user.last_name}",
                       email: user.email)
    end
  end

  task projects: :environment do
    LetsFreckle::Project.all.each do |project|
      p1 = Project.find_or_create_by(id: project.id)
      p1.update_columns(name: project.name)
    end
  end

  desc "Import new Freckle entries"
  task entries: [:users, :projects] do
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date

    puts "start importing entries from #{start_date} to #{end_date}"

    LetsFreckle::Entry.all(all_pages: true,
                           from: start_date,
                           to:  end_date).each do |entry|
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
    Project.calculate_leaderboard
    User.calculate_leaderboard
  end
end
