class UserLeaderboard < ActiveRecord::Base
  include CurrentWeek
  include LeaderboardCalculation

  belongs_to :user

  def self.with_logged_minutes
    where.not(total_minutes: 0)
  end

  def name
    user.name
  end
end
