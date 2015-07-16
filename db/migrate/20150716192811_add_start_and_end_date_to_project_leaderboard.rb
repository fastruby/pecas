class AddStartAndEndDateToProjectLeaderboard < ActiveRecord::Migration
  def change
    add_column :project_leaderboards, :start_date, :date
    add_column :project_leaderboards, :end_date, :date
  end
end
