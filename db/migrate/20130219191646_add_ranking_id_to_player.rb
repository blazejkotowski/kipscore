class AddRankingIdToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :ranking_id, :integer
    add_index :players, :ranking_id
  end
end
