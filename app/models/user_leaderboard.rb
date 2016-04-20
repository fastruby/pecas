class UserLeaderboard < ActiveRecord::Base
  include LeaderboardScopes
  include LeaderboardCalculation

  belongs_to :user

  def name
    user.name
  end
end
