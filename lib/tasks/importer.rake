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
    LetsFreckle::Entry.all(all_pages: true,
                           from: '2015-07-01',
                           to: '2015-07-16').each do |entry|
      e1 = Entry.find_or_create_by(id: entry.id)
      e1.update_columns(
        description: entry.description,
        minutes:     entry.minutes,
        date:        entry.date,
        user_id:     entry.user_id,
        project_id:  entry.project_id
      )
    end
  end
end

namespace :calc do
  desc "Calculate Leaderboards"
  task leaderboards: :environment do
    Project.all.each do |project|
      start_date = Time.now.beginning_of_week.to_date
      end_date = Time.now.end_of_week.to_date
      minutes = project.entries.where(date: start_date..end_date).sum(:minutes)
      project_leaderboard = ProjectLeaderboard.find_or_create_by(project_id: project.id,
                                                                 start_date: start_date,
                                                                 end_date: end_date)
      project_leaderboard.update_column(:total_minutes, minutes)
    end

    User.all.each do |user|
      start_date = Time.now.beginning_of_week.to_date
      end_date = Time.now.end_of_week.to_date
      minutes = user.entries.where(date: start_date..end_date).sum(:minutes)
      user_leaderboard = UserLeaderboard.find_or_create_by(user_id: user.id,
                                                           start_date: start_date,
                                                           end_date: end_date)
      user_leaderboard.update_column(:total_minutes, minutes)
    end
  end
end
