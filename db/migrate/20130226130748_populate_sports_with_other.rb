class PopulateSportsWithOther < ActiveRecord::Migration
  def up
    Sport.create :name => "Other"
  end

  def down
    Sport.find_by_name("Other").delete
  end
end
