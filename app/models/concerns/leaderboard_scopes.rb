require 'active_support/concern'

module LeaderboardScopes
  extend ActiveSupport::Concern

  included do
    def self.week(from, to)
      where(start_date: from, end_date: to).order('total_minutes desc')
    end

    def self.with_logged_minutes
      where.not(total_minutes: 0)
    end
  end
end
