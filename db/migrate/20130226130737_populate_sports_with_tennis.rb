class PopulateSportsWithTennis < ActiveRecord::Migration
  def up
    Sport.create :name => "Tennis"
  end

  def down
    Sport.find_by_name("Tennis").delete
  end
end
