require 'active_support/concern'

module LeaderboardCalculation
  extend ActiveSupport::Concern

  included do
    def self.calculate
      start_date = Time.now.beginning_of_week.to_date
      end_date = Time.now.end_of_week.to_date
      model_klass = self.name.gsub("Leaderboard", "").constantize

      model_klass.find_each do |record|
        leaderboard = self.find_or_create_by(
          "#{model_klass.name.downcase}_id" => record.id,
          start_date: start_date,
          end_date: end_date)
        leaderboard.update_column(:total_minutes, record.minutes_of_current_week)
      end
    end
  end
end
