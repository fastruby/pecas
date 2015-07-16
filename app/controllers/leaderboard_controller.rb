class LeaderboardController < ApplicationController
  def users
    @leaderboards = UserLeaderboard.includes(:user).current_week
    render 'partials/leaderboard_table'
  end

  def projects
    @leaderboards = ProjectLeaderboard.includes(:project).current_week
    render 'partials/leaderboard_table'
  end
end
