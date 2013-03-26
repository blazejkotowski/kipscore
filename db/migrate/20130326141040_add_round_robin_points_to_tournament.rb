class AddRoundRobinPointsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :win_points, :integer
    add_column :tournaments, :loss_points, :integer
    add_column :tournaments, :draw_points, :integer
    add_column :tournaments, :base_points, :integer
  end
end
