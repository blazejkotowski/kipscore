class AddStateToPlayerAssignment < ActiveRecord::Migration
  def change
    add_column :player_assignments, :state, :string
    add_index :player_assignments, :state
  end
end
