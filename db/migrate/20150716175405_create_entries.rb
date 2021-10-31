class CreateEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :entries do |t|
      t.text :description
      t.integer :minutes
      t.integer :user_id
      t.integer :project_id
      t.date :date

      t.timestamps null: false
    end
  end
end
