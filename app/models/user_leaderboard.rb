class UserLeaderboard < ActiveRecord::Base
  include CurrentWeek
  include LeaderboardCalculation
  
  belongs_to :user

  def name
    user.name
  end
end
