class UserProfile < ActiveRecord::Base
  attr_accessible :club, :description, :avatar, :user
  has_attached_file :avatar, :styles => { :small => "150x150>", :medium => "250x250>" }
  
  belongs_to :user
end
