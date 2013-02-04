desc "This task is called by the Heroku scheduler add-on"

task :sync_players => :environment do
  puts "Synchronizing players database"
  Player.sync
  puts "done."
end
