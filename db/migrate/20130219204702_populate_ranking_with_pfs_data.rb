class PopulateRankingWithPfsData < ActiveRecord::Migration
  def up
    ["Pfs Open", "Pfs Damski Open"].each do |name|
      r = Ranking.find_or_initialize_by_name name
      r.save if r.new_record?
    end
  end

  def down
    ["Pfs Open", "Pfs Damski Open"].each do |name|
      r = Ranking.find_by_name(name).delete
    end
  end
end
