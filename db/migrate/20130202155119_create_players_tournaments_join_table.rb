class CreatePlayersTournamentsJoinTable < ActiveRecord::Migration
  def up
    create_table :players_tournaments, :id => false do |t|
      t.integer :player_id
      t.integer :tournament_id
    end
  end

  def down
    drop_table :players_tournaments
  end
end
