class AddAttachmentAvatarToUserProfiles < ActiveRecord::Migration
  def self.up
    change_table :user_profiles do |t|
      t.column :avatar_file_name, :string
      t.column :avatar_content_type, :string
      t.column :avatar_file_size, :integer
      t.column :avatar_updated_at, :datetime
    end
  end

  def self.down
    drop_attached_file :user_profiles, :avatar
  end
end
