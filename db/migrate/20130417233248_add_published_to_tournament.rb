class AddPublishedToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :published, :boolean, :default => false
  end
end
