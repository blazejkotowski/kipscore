class Sport < ActiveRecord::Base
  attr_accessible :name
  has_many :tournaments
  has_many :rankings
  
  validates_uniqueness_of :name
end
