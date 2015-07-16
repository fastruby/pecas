require 'active_support/concern'

module CurrentWeek
  extend ActiveSupport::Concern

  included do
    scope :current_week, lambda {
      where(start_date: Time.now.beginning_of_week.to_date, end_date: Time.now.end_of_week.to_date)
       .order('total_minutes desc')
    }
  end
end
