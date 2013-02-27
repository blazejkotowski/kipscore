class UserProfile < ActiveRecord::Base
  attr_accessible :club, :link, :description, :avatar, :user, :public
  has_attached_file :avatar, :styles => { :small => "150x150>", :medium => "250x250>" }
  
  belongs_to :user
  
  validate :link, :format => /^[a-z0-9-.]+$/, :blank => true, :nil => true
  validates_attachment_content_type :avatar, :content_type => /image/
  validates_attachment :avatar, :size => { :less_than => 1.megabyte }
  
end
