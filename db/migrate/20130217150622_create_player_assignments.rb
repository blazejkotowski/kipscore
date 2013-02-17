class CreatePlayerAssignments < ActiveRecord::Migration
  def change
    create_table :player_assignments do |t|
      t.integer :tournament_id
      t.integer :player_id
      t.integer :position
      t.string :email

      t.timestamps
    end
    add_index :player_assignments, :tournament_id
    add_index :player_assignments, :player_id
  end
end
