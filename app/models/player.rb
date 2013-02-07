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
    
    begin 
      page = Nokogiri::HTML(open(ranking_url))
    rescue
      puts "Can't conenct to the site. Try again later"
      return
    end
    
    players = []
    
    page.css("table.notowanie > tr").each do |line|
      rank = line.at_css("td.miejsce")
      next if rank.nil?
      rank = rank.content.to_i
      name = line.at_css("td.nazwa > a").content
      players.append( { :rank=> rank, :name => name, :fetched => true } )
    end
   
    new_players = 0 
    players.map! do |player| 
      p = Player.fetched.find_or_initialize_by_name player[:name]
      new_players += 1 if p.new_record?
      p.update_attributes player
      p
    end
    
    create_indexes(players)
    
    puts "Fetched #{new_players} new players and #{players.size-new_players} updated."
    
  end
  
  def self.create_indexes(players = :all)
    if players == :all
      players = fetched
    end
    
    $redis.flushall
    players.each { |player| add_indexes(player) }
    
  end
  
  def self.autocomplete(term)
    Rails.cache.fetch(["autocomplete", term.downcase.parameterize]) do
      players = $redis.smembers("autocomplete:#{term.downcase.parameterize}").map { |item| JSON.parse(item).symbolize_keys }
      players.map do |player|
        { :label => "#{player[:rank]}. #{player[:name]}", :value => player[:name], :rank => player[:rank] }
      end
    end
  end
  
  private
    def self.add_indexes(player)
      words = player.name.split
      0.upto words.size do |words_number|
        (0..words.size-words_number-1).each do |start|
          add_index words[start..start+words_number].join(" ").downcase, { :name => player.name, :rank => player.rank }.to_json
        end
      end
    end
    
    def self.add_index(key, value)
      Settings.autocomplete_index_length.upto key.size do |i|
        k = key[0...i]
        next if k.nil?
        next if k.size < Settings.autocomplete_index_length
        $redis.sadd "autocomplete:#{k.parameterize}", value
      end
    end 
  
end
