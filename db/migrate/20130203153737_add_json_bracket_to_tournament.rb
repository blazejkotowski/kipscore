class AddJsonBracketToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :json_bracket, :text
  end
end
