class AddAttachmentAvatarToUserProfiles < ActiveRecord::Migration
  def self.up
    change_table :user_profiles do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :user_profiles, :avatar
  end
end
