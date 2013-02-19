class RankingCrawler::Pfs < RankingCrawler::RankingCrawler
  
  attr_accessor :link_content
  
  def initialize
    @base_url = "http://pfs.ligowe.info/"
    super
  end

  def players_list
    ranking_url = nil
 
    page.css("#rankings a").each do |link|
      name = link.at_css(".nazwa")
      next if name.nil?
      ranking_url = URI.join(base_url, link["href"]) if name.content == @link_content
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
      p = Player.fetched.find_or_initialize_by_name_and_ranking_id(player[:name], ranking.id)
      new_players += 1 if p.new_record?
      p.assign_attributes player
      p
    end

    puts "Fetched #{new_players} new players and #{players.size-new_players} updated."
    
    players
  end
end
