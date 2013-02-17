class AddEmailCodeToPlayerAssociation < ActiveRecord::Migration
  def change
    add_column :player_associations, :email_code, :string
    add_index :player_associations, :email_code
  end
end
