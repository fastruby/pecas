class ProjectLeaderboard < ActiveRecord::Base
  include CurrentWeek
  include LeaderboardCalculation

  belongs_to :project

  def name
    project.name
  end
end
