class AddContactToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :contact, :text
  end
end
