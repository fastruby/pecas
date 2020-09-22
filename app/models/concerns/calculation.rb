require 'active_support/concern'

module Calculation
  extend ActiveSupport::Concern

  def minutes_of_week(weeks_ago)
    start_date = (Time.now.beginning_of_week - weeks_ago.week).to_date
    end_date = (Time.now.end_of_week - weeks_ago.week).to_date
    entries.where(date: start_date..end_date).sum(:minutes)
  end
end
