namespace :import do
  desc "Import new Freckle entries"
  task entries: :environment do
    LetsFreckle::Project.all.each do |project|
      Project.find_or_create_by(id: project.id, name: project.name)
    end

    # TODO: GET PERMISSIONS :(
    # LetsFreckle::User.all.each do |user|
    #   User.find_or_create_by(id: user.id, name: user.name)
    # end
    User.find_or_create_by(id: 34429, name: "Mauro Otonelli")

    LetsFreckle::Entry.all(all_pages: true).each do |entry|
      Entry.find_or_create_by(
        id:          entry.id,
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
      minutes = project.entries.sum(:minutes)
      project_leaderboard = ProjectLeaderboard.find_or_create_by(project_id: project.id)
      project_leaderboard.update_column(:total_minutes, minutes)
    end

    User.all.each do |user|
      minutes = user.entries.sum(:minutes)
      user_leaderboard = UserLeaderboard.find_or_create_by(user_id: user.id)
      user_leaderboard.update_column(:total_minutes, minutes)
    end
  end
end
