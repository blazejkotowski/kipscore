class ChangeColumnName < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.rename :user_created, :fetched
    end
  end
end
