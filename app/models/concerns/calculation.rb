require 'active_support/concern'

module Calculation
  extend ActiveSupport::Concern

  def minutes_of_current_week
    start_date = Time.now.beginning_of_week.to_date
    end_date = Time.now.end_of_week.to_date
    entries.where(date: start_date..end_date).sum(:minutes)
  end
end
