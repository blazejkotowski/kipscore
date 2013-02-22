class AddJsonResultsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :json_results, :text
  end
end
