class AddOpenToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :open, :boolean, :default => true
  end
end
