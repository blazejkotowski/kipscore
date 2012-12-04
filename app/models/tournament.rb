class Tournament < ActiveRecord::Base
  attr_accessible :active, :name, :start_date
  belongs_to :user
  
end
