require 'active_support/concern'

module LeaderboardCalculation
  extend ActiveSupport::Concern

  included do
    def self.calculate
      [1, 0].each do |weeks_ago|
        start_date = Time.now.beginning_of_week.to_date - weeks_ago.weeks
        end_date = Time.now.end_of_week.to_date - weeks_ago.weeks
        model_klass = self.name.gsub("Leaderboard", "").constantize

        puts "Calculating time from #{start_date} to #{end_date} of #{model_klass}"

        model_klass.find_each do |record|
          leaderboard = self.find_or_create_by(
            "#{model_klass.name.downcase}_id" => record.id,
            start_date: start_date,
            end_date: end_date)
          leaderboard.update_column(:total_minutes, record.minutes_of_week(weeks_ago))
        end
      end
    end
  end
end
