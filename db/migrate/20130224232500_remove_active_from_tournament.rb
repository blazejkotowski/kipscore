class RemoveActiveFromTournament < ActiveRecord::Migration
  def up
    Tournament.all.each do |t| 
      if t.active
        t.update_attribute :state, "started"
      else
        t.update_attribute :state, "created"
      end
    end
    remove_column :tournaments, :active
  end

  def down
    add_column :tournaments, :state, :boolean, :default => true
  end
end
