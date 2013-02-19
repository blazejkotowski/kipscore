# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  rank       :integer          default(-1)
#  fetched    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ActiveRecord::Base
  attr_accessible :name, :rank, :fetched, :ranking
  #has_and_belongs_to_many :tournaments
  has_many :player_assignments, :dependent => :delete_all
  has_many :tournaments, :through => :player_associations
  
  belongs_to :ranking
  
  validates_presence_of :name
  
  before_create :check_ranking
  
  scope :best, order('rank')
  scope :latest, order('created_at DESC')
  scope :fetched, where(:fetched => true)
  
  def self.autocomplete(ranking_id, term)
    players = $redis.smembers("autocomplete:#{ranking_id}:#{term.downcase.parameterize}").map { |item| JSON.parse(item).symbolize_keys }
    players.map do |player|
      { :label => "#{player[:rank]}. #{player[:name]}", :value => player[:name], :rank => player[:rank] }
    end
  end
  
  private
    def check_ranking
      self.rank = nil if self.rank.to_i < 1
    end
  
end
