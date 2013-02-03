class AddDescriptionToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :description, :text
  end
end
