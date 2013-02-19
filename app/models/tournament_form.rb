class TournamentForm < ActiveRecord::Base
  belongs_to :tournament
  attr_accessible :comment, :licence, :name, :phone, :rank
  
end
