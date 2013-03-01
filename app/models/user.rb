class User < ActiveRecord::Base
  if Settings.beta_version
    devise :database_authenticatable,
         :recoverable, :rememberable, :confirmable
  else
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, 
         :omniauthable, :omniauth_providers => [:facebook]
  end

  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :provider, :uid, :admin, :profile

  before_create :validations
  before_create :create_user_profile
                  
  has_many :tournaments
  has_one :profile, :class_name => "UserProfile"

  validates_presence_of :name
  validates_presence_of :encrypted_password
  validates :email, :email => true, :presence => true, :uniqueness => true
  validates_confirmation_of :password
  
  scope :with_profile, includes(:profile)
  
  def admin?
    admin
  end
  
  private
    def validations
      validates_presence_of :password
      validates_presence_of :password_confirmation
    end
    
    def create_user_profile
      build_profile if profile.nil?
    end
end
