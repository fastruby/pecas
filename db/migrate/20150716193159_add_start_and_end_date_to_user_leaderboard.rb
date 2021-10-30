class AddStartAndEndDateToUserLeaderboard < ActiveRecord::Migration[4.2]
  def change
    add_column :user_leaderboards, :start_date, :date
    add_column :user_leaderboards, :end_date, :date
  end
end
