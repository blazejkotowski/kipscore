class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :provider, :uid
  before_create :validations
                  
  has_many :tournaments

  validates_presence_of :name
  validates_presence_of :encrypted_password
  validates :email, :email => true, :presence => true, :uniqueness => true
  validates_confirmation_of :password
  
  private
    def validations
      validates_presence_of :password
      validates_presence_of :password_confirmation
    end
end
