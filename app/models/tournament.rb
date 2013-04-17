# == Schema Information
#
# Table name: tournaments
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  name         :string(255)
#  start_date   :datetime
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  description  :text
#  json_bracket :text
#

class Tournament < ActiveRecord::Base
  extend FriendlyId
  
  friendly_id :name, :use => :slugged
  
  attr_accessible :state, :name, :sport_id, :start_date,
                  :description, :open, :json_results, :type,
                  :json_bracket, :published
  
  belongs_to :user
  belongs_to :sport

  has_one :tournament_form, :dependent => :destroy
  accepts_nested_attributes_for :tournament_form
  
  attr_accessible :tournament_form_attributes
  
  has_many :player_associations, :dependent => :delete_all
  has_many :players, :through => :player_associations do
    def active
      where('player_associations.state = ?', "active")
    end
    def inactive
      where('player_associations.state = ?', "inactive")
    end
    def confirmed
      where('player_associations.state = ?', "confirmed")
    end
    def likely
      where('player_associations.state <> ?', "inactive")
    end
  end
  
  validates_presence_of :name
  validates_presence_of :start_date
  validates_presence_of :description
  validates_presence_of :sport_id
  validates_presence_of :type
  validate :check_type
  
  before_create :create_tournament_form
  
  scope :with_sport, includes(:sport)
  scope :with_form, includes(:tournament_form)
  scope :with_user, includes(:user => [:profile])
  
  scope :published, where('published = ?', true)
  scope :unpublished, where('published = ?', false)
  
  scope :finished, -> {with_state(:finished)}
  scope :started, -> {with_state(:started)}
  scope :created, -> {with_state(:created)}
  scope :managable, -> {without_state(:finished)}
  
  state_machine :initial => :created do
    event :start do
      transition :created => :started
    end
    
    event :finish do
      transition :started => :finished
    end
    
    event :stop do
      transition :started => :created
    end
    
    after_transition :started => :created do |tournament, transition|
      tournament.update_attributes :json_bracket => nil, :json_results => nil
    end
    
    state :created
    state :started
    state :finished
  end  
  
  def publish
    update_attribute :published, true  
  end
  
  def unpublish
    update_attribute :published, false
  end
  
  def joinable?
    !self.started? && !self.finished? && self.open
  end
  
  def results
    if json_results.present?
      JSON.parse json_results
    else
      { :places_number => players.confirmed.size }
    end
  end
  
  private
    def create_tournament_form
      build_tournament_form
      true
    end
    
    def check_type
      klass = Module.const_get(type)
      klass.is_a?(Class)
    rescue NameError
      errors.add(:type, "should be one from the list")
    end
  
end
