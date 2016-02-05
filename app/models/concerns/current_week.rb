require 'active_support/concern'

module CurrentWeek
  extend ActiveSupport::Concern

  included do
    scope :week, lambda { |from, to|
      where(start_date: from, end_date: to).order('total_minutes desc')
    }
  end
end
