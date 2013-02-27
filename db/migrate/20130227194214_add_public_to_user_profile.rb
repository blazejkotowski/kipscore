class AddPublicToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :public, :boolean
    add_column :user_profiles, :link, :string
    add_index :user_profiles, :link
  end
end
