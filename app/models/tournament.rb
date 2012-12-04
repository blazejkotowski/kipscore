class Tournament < ActiveRecord::Base
  attr_accessible :active, :name, :start_date, :user_id
end
