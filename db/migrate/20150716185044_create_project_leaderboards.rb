class CreateProjectLeaderboards < ActiveRecord::Migration
  def change
    create_table :project_leaderboards do |t|
      t.integer :project_id
      t.integer :total_minutes

      t.timestamps null: false
    end
  end
end
