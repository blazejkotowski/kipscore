module TournamentsHelper

  def manage_tournament_path(tournament, attrs = {})
    tournaments_user_path attrs.merge({:anchor => "tid=#{tournament.id}"})
  end
  
  def tournament_progress_path(tournament, attrs = {})
    if tournament.type == "RoundRobinTournament"
      tournament_rounds_path tournament, attrs
    elsif tournament.type == "BracketTournament"
      tournament_bracket_path tournament, attrs
    end
  end
end
