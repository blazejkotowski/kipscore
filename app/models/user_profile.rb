class UserProfile < ActiveRecord::Base
  attr_accessible :club, :link, :description, :avatar, :user, :contact,
                  :remote_avatar_url

  mount_uploader :avatar, AvatarUploader
  
  belongs_to :user
  
  validates_format_of :link, :with => /^[a-zA-Z0-9-]+$/, :allow_blank => true, :allow_nil => true
  validates_uniqueness_of :link, :allow_blank => true, :allow_nil => true
  #:allow_blank => true, :allow_blank => true, :uniqueness => true
  
  scope :with_user, includes(:user)
  
end
