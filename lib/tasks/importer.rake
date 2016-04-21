namespace :import do

  task users: :environment do
    FreckleService.import_users
  end

  task projects: :environment do
    FreckleService.import_projects
  end

  desc "Import new Freckle entries"
  task entries: [:users, :projects, :environment] do
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date

    puts "start importing entries from #{start_date} to #{end_date}"

    FreckleService.import_entries(start_date, end_date)

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
