class ProjectLeaderboard < ActiveRecord::Base
  include CurrentWeek

  belongs_to :project

  def name
    project.name
  end
end
