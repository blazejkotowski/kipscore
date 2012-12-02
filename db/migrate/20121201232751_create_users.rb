class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :authentication_token
      t.string :password_digest

      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :authentication_token, :unique => true
  end
end
