class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :club
      t.integer :user_id
      t.text :description

      t.timestamps
    end
    # create user profiles for existing users
    User.all.each { |user| user.create_profile unless user.profile.present? }
  end
end
