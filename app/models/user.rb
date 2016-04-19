class User < ActiveRecord::Base
  include Calculation

  has_many :entries

  def self.send_reminders
    return if Date.today.saturday? || Date.today.sunday? || holiday?

    User.all.each do |user|
      if user.entries.today.count == 0
        Reminder.send_to(user).deliver
      end
    end
  end

  private
  
  def self.holiday?
    ENV["COUNTRY_CODE"] && Holidays.on(Date.today, ENV["COUNTRY_CODE"]).any?
  end
end
