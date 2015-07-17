class Project < ActiveRecord::Base
  include Calculation

  has_many :entries
end
