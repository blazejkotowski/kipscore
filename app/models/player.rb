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
  attr_accessible :name, :rank, :fetched
  has_and_belongs_to_many :tournaments
  
  validates_presence_of :name
  
  scope :best, order('rank')
  scope :latest, order('created_at DESC')
  scope :fetched, where(:fetched => true)
  
  def self.sync
    base_url = "http://pfs.ligowe.info/"
    
    require 'open-uri'
    page = Nokogiri::HTML(open(base_url))
    
    ranking_url = nil
    page.css("#rankings a").each do |link|
      name = link.at_css(".nazwa")
      next if name.nil?
      ranking_url = URI.join(base_url, link["href"]) if name.content == "OPEN"
    end
    puts "Found ranking at #{ranking_url}." unless ranking_url.nil?
    
    page = Nokogiri::HTML(open(ranking_url))
    
    players = []
    
    page.css("table.notowanie > tr").each do |line|
      rank = line.at_css("td.miejsce")
      next if rank.nil?
      rank = rank.content.to_i
      name = line.at_css("td.nazwa > a").content
      players.append( { :rank=> rank, :name => name, :fetched => true } )
    end
   
    new_players = 0 
    players.map do |player| 
      p = Player.find_or_initialize_by_name_and_fetched player[:name], true
      new_players += 1 if p.new_record?
      p.update_attributes player
    end
    
    puts "Fetched #{new_players} new players and #{players.size-new_players} updated."
    
  end
  
end
