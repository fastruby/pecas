class LeaderboardController < ApplicationController
  def users
    @users = UserLeaderboard.includes(:user).order(:total_minutes)
  end

  def projects
    @projects = ProjectLeaderboard.all.order(:total_minutes)
  end
end
