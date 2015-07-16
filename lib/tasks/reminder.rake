namespace :reminder do
  desc "Sends reminder emails to users"
  task email: :environment do
    User.each do |user|
      Reminder.send_to(user).deliver if user.entries.today.count == 0
    end
  end
end
