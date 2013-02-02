class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :rank, :default => -1
      t.boolean :user_created, :default => false

      t.timestamps
    end
  end
end
