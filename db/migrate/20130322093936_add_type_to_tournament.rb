class AddTypeToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :type, :string
    Tournament.all.each { |t| t.update_attribute :type, "BracketTournament" }
  end
end
