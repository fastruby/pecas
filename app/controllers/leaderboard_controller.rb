class LeaderboardController < ApplicationController
  def users
    @leaderboards = UserLeaderboard.includes(:user).week(start_date, end_date)
      .with_logged_minutes
    render 'partials/leaderboard_table'
  end

  def projects
    @leaderboards = ProjectLeaderboard.includes(:project).week(start_date, end_date)
    render 'partials/leaderboard_table'
  end

  private

    def start_date
      @start_date = Time.now.beginning_of_week.to_date - weeks_ago.weeks
    end

    def end_date
      @end_date = Time.now.end_of_week.to_date - weeks_ago.weeks
    end

    def weeks_ago
      @weeks_ago = (params[:weeks_ago] || 0).to_i
    end
end
