class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  delegate :email, prefix: "user", to: :user

  MINUTES_PER_HOUR = 60

  scope :today, lambda { where(date: Date.today) }
  scope :for_users_by_email, ->(emails) { joins(:user).where('users.email IN (?)', emails).preload(:user) }

  def length
    hour_value = minutes / MINUTES_PER_HOUR
    minute_value = minutes % MINUTES_PER_HOUR
    [time_label("hour", hour_value), time_label("minute", minute_value)].compact.join(", ")
  end

    private

    def time_label(label, value)
      return "#{value} #{label.pluralize(value)}" if value > 0
    end
end
