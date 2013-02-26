class PopulateSportsWithSquash < ActiveRecord::Migration
  def up
    squash = Sport.create(:name => "Squash")
    Tournament.all.each { |t| t.update_attribute :sport_id, squash.id }
    Ranking.all.each { |r| r.update_attribute :sport_id, squash.id }
  end
  
  def down
  end

end
