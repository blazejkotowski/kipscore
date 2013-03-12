class RankingCrawler::RankingCrawler
  require 'open-uri'
  
  attr_accessor :base_url, :page, :ranking, :name
  
  def self.sync_all
    $redis.flushall
    
    # fetch rankings from settings
    rankings = Settings.rankings

    # fetch rankings from database
    # rankings = Ranking.all
    
    rankings.each do |ranking|
      r = "#{name.split(':').first}::#{ranking.name.split.join}".constantize.new
      r.sync
    end
    create_indexes(:all)
  end
    
  def self.create_indexes(players = :all)
    if players == :all
      players = Player.fetched
    end
    
    $redis.flushall
    players.each { |player| add_indexes(player) }
  end
  
  
  def page
    @page ||= Nokogiri::HTML(open(self.base_url))
  end
  
  def name
    @name ||= self.class.name.split(':').last.underscore.split('_').map(&:capitalize).join(' ')
  end
  
  def players_list
  end
  
  def sport
    @sport ||= Sport.find_or_initialize_by_name(@sport_name)
    @sport.save if @sport.new_record?
    @sport
  end
  
  def ranking
    @ranking ||= Ranking.find_or_initialize_by_name_and_sport_id(name, sport.id)
    @ranking.save if @ranking.new_record?
    @ranking
  end
  
  def sync
    players = self.players_list
    players.each(&:save)
  end
  
  private
    def self.add_indexes(player)
      words = player.name.split
      0.upto words.size do |words_number|
        (0..words.size-words_number-1).each do |start|
          add_index player.ranking_id, words[start..start+words_number].join(" ").downcase, { :name => player.name, :rank => player.rank }.to_json
        end
      end
    end
    
    def self.add_index(ranking_id, key, value)
      Settings.autocomplete_index_length.upto key.size do |i|
        k = key[0...i]
        next if k.nil?
        next if k.size < Settings.autocomplete_index_length
        $redis.sadd "autocomplete:#{ranking_id}:#{k.parameterize}", value
        end
    end
    
end

