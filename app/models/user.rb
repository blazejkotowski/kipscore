# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  authentication_token :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :authentication_token, :email, :name, :password, :password_confirmation
  has_many :tournaments
  
  has_secure_password
  before_save :create_authentication_token
  
  validates_presence_of :name
  validates_presence_of :password_digest
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates :email, :format => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :presence => true, :uniqueness => true
  validates_confirmation_of :password
  
  private
    def create_authentication_token
      self.authentication_token = SecureRandom.urlsafe_base64
    end
  
end
