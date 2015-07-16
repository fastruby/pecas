class CreateUserLeaderboards < ActiveRecord::Migration
  def change
    create_table :user_leaderboards do |t|
      t.integer :user_id
      t.integer :total_minutes

      t.timestamps null: false
    end
  end
end
