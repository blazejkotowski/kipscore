module TournamentsHelper

  def manage_tournament_path(tournament, attrs = {})
    tournaments_user_path attrs.merge({:anchor => "tid=#{tournament.id}"})
  end
  
end
