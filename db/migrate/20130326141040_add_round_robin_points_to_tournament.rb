class AddRoundRobinPointsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :win_points, :integer, :default => 0
    add_column :tournaments, :loss_points, :integer, :default => 0
    add_column :tournaments, :draw_points, :integer, :default => 0
    add_column :tournaments, :base_points, :integer, :default => 0
  end
end
