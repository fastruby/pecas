class User < ActiveRecord::Base
  has_many :entries
end
