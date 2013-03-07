class PaperclipToCarrierwave < ActiveRecord::Migration
  def up
    remove_column :user_profiles, :avatar_file_name
    remove_column :user_profiles, :avatar_content_type
    remove_column :user_profiles, :avatar_file_size
    remove_column :user_profiles, :avatar_updated_at
    add_column :user_profiles, :avatar, :string
  end

  def down
    remove_column :user_profiles, :avatar
    add_column :user_profiles, :avatar_file_name, :string
    add_column :user_profiles, :avatar_content_type, :string
    add_column :user_profiles, :avatar_file_size, :integer
    add_column :user_profiles, :avatar_updated_at, :datetime
  end
end
