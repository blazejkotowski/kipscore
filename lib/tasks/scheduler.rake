
namespace :ranking do
  
  desc "This task is called by the Heroku scheduler add-on"
  task :sync_players => :environment do
    puts "Synchronizing players database"
    RankingCrawler::RankingCrawler.sync_all
    puts "done."
  end

  desc "Creating indexes in Redis"
  task :reset_indexes => :environment do
    puts "Creating indexes in Redis."
    Player.create_indexes
    puts "done."
  end
  
end

desc "Keeping app awake"
task :call_app => :environment do
  uri = URI.parse('http://beta.kipscore.pl/')
  open(uri).read
end
