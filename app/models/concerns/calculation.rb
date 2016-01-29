require 'active_support/concern'

module Calculation
  extend ActiveSupport::Concern

  def minutes_of_current_week
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date
    entries.where(date: start_date..end_date).sum(:minutes)
  end

  included do
    def self.calculate_leaderboard
      start_date = Time.now.beginning_of_week.to_date
      end_date = Time.now.end_of_week.to_date

      self.all.each do |record|
        leaderboard_klass = "#{self.name}Leaderboard".constantize
        leaderboard = leaderboard_klass.find_or_create_by(
          "#{self.name.downcase}_id" => record.id,
          start_date: start_date,
          end_date: end_date)
        leaderboard.update_column(:total_minutes, record.minutes_of_current_week)
      end
    end
  end
end
