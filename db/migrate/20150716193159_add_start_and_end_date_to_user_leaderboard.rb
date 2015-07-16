class AddStartAndEndDateToUserLeaderboard < ActiveRecord::Migration
  def change
    add_column :user_leaderboards, :start_date, :date
    add_column :user_leaderboards, :end_date, :date
  end
end
