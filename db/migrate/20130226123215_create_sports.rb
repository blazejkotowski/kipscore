class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string :name
      t.timestamps
    end
    add_column :tournaments, :sport_id, :integer
    add_index :tournaments, :sport_id
    
    add_column :rankings, :sport_id, :integer
    add_index :rankings, :sport_id
  end
end
