require 'securerandom'

class PlayerAssociation < ActiveRecord::Base
  attr_accessible :email, :player_id, :position, :tournament_id, :player
  attr_accessible :tournament, :state, :email_code, :phone, :comment, :licence

  belongs_to :player, :dependent => :destroy
  belongs_to :tournament, :dependent => :destroy
  
  before_create :set_email_code
  
  validates :email, :email => true, :allow_nil => true
  
  default_scope includes(:tournament, :player)
  
  scope :active, -> { with_state(:active) }
  scope :inactive, -> { with_state(:inactive) }
  scope :confirmed, -> { with_state(:confirmed).order("players.rank") }
  scope :likely, -> { with_state([:active, :confirmed]).order("state DESC, created_at DESC") }
  
  state_machine :initial => :inactive do
    
    event :activate do
      transition :inactive => :active
    end
    
    event :confirm do
      transition :active => :confirmed
    end
    
    event :deactivate do
      transition :active => :inactive
    end
    
    state :active
    state :inactive
    state :confirmed
  end
  
  
  def try_to_confirm(hash_code)
    if active? && hash_code == email_code
      confirm
      set_random_hash
    end
  end
  
  def try_to_activate(hash_code)
    if inactive? && hash_code == email_code
      activate
      set_random_hash
    end
  end
  
  private
  
    def set_email_code
      self.email_code = random_hash
    end
  
    def set_random_hash
      update_attribute :email_code, random_hash
    end
    
    def random_hash
      SecureRandom.hex(16)
    end
    
end
