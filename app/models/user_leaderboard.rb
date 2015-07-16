class UserLeaderboard < ActiveRecord::Base
  include CurrentWeek

  belongs_to :user

  def name
    user.name
  end
end
