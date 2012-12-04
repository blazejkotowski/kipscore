class Tournament < ActiveRecord::Base
  attr_accessible :active, :name, :start_date
  belongs_to :user
  
  validates_presence_of :name
  validates_presence_of :start_date
end
