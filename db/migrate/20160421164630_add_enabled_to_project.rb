class AddEnabledToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :enabled, :boolean
  end
end
