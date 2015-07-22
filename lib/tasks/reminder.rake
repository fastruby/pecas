namespace :reminder do
  desc "Sends reminder emails to users"
  task email: ['import:entries'] do
    p 'start sending reminders'
    User.send_reminders
    p 'finished sending reminders'
  end
end
