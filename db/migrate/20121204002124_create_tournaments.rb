class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.integer :user_id
      t.string :name
      t.datetime :start_date
      t.boolean :active

      t.timestamps
    end
  end
end
