class UserProfile < ActiveRecord::Base
  attr_accessible :club, :link, :description, :avatar, :user, :contact
  has_attached_file :avatar, :styles => { :small => "150x150>", :medium => "250x250>" }
  
  belongs_to :user
  
  validates_format_of :link, :with => /^[a-zA-Z0-9-]+$/
  validate :link, :allow_blank => true, :uniqueness => true, :allow_nil => true
  #:allow_blank => true, :allow_blank => true, :uniqueness => true
  validates_attachment_content_type :avatar, :content_type => /image/
  validates_attachment :avatar, :size => { :less_than => 1.megabyte }
  
  scope :with_user, includes(:user)
  
end
