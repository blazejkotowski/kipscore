class AddPhoneAndLicenceAndCommentToPlayerAssociation < ActiveRecord::Migration
  def change
    add_column :player_associations, :phone, :string
    add_column :player_associations, :licence, :string
    add_column :player_associations, :comment, :text
  end
end
