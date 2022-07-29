class AddMissingHoursNotificationEnabledToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :missing_hours_notification_enabled, :boolean
  end
end
