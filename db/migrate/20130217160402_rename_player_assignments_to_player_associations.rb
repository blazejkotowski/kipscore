class RenamePlayerAssignmentsToPlayerAssociations < ActiveRecord::Migration
  def change
    rename_table :player_assignments, :player_associations
  end
end
