class RankingCrawler::PfsOpen < RankingCrawler::Pfs
  
  def initialize
    @link_content = "OPEN"
    super
  end

end
