namespace :import do

  task users: :environment do
    NokoService.import_users
  end

  task projects: :environment do
    NokoService.import_projects
  end

  desc "Import new Noko entries"
  task entries: [:users, :projects, :environment] do
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.next_week(:saturday).to_date

    puts "start importing entries from #{start_date} to #{end_date}"

    NokoService.import_entries(start_date, end_date)

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
