class Ranking < ActiveRecord::Base
  attr_accessible :name
  has_many :players
  belongs_to :sport
end
