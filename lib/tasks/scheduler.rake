desc "This task is called by the Heroku scheduler add-on"

task :sync_players => :environment do
  puts "Synchronizing players database"
  Player.sync
  Rails.cache.delete_matched "autocomplete" 
  puts "done."
end
