class AddKipcoinsToUser < ActiveRecord::Migration
  def change
    add_column :users, :kipcoins, :integer, :default => 32
  end
end
