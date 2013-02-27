class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :club
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
