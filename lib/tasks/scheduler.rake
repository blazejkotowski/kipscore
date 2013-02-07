
namespace :ranking do
  
  desc "This task is called by the Heroku scheduler add-on"
  task :sync_players => :environment do
    puts "Synchronizing players database"
    Player.sync
    clear_cache
    puts "done."
  end

  desc "Creating indexes in Redis"
  task :reset_indexes => :environment do
    puts "Creating indexes in Redis."
    Player.create_indexes
    clear_cache
    puts "done."
  end
  
  private
    def clear_cache
      Rails.cache.delete_matched "autocomplete"
    end

end
