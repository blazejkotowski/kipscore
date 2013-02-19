class CreateTournamentForms < ActiveRecord::Migration
  def change
    create_table :tournament_forms do |t|
      t.boolean :name, :default => true
      t.boolean :rank, :default => true
      t.boolean :phone, :default => false
      t.boolean :licence, :default => false
      t.boolean :comment, :default => false
      t.references :tournament

      t.timestamps
    end
    add_index :tournament_forms, :tournament_id
  end
end
