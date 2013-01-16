class Kipscore.Models.Tournament extends Backbone.Model
  defaults:
    'players_number': 0
    'bracket_size': 0
    'max_position': 0
    'min_position': 0
  
  initialize: ->
    power = 1
    while power < this.get('players_number')
      power *= 2
    
    this.set 'players_number', power  
    this.set 'bracket_size', 2*(power/2)-1
    if this.get('max_position') == 0
      this.set 'max_position', power
      this.set 'min_position', 1
    
    bracket_size = this.get('bracket_size')
    bracket = this.get('bracket')
    
    # Create empty bracket if not provided
    if bracket is undefined
      matches = new Kipscore.Collections.Matches()
      iter = this.get 'bracket_size'
      while iter > 0
        new_match = new Kipscore.Models.Match()
        matches.add new_match
        iter--
      bracket = matches
      this.set 'bracket', matches
    
    # Add next (blank) matches
    while bracket.length < bracket_size
      match = new Kipscore.Models.Match()
      bracket.add match, { at: 0 }
    
    # Perform empty tournaments for next tours  
    this.createRelatedTournaments()
      
  # Creates losers tournaments
  createRelatedTournaments: ->
    tournaments = new Kipscore.Collections.Tournaments()
    
    cur_players = this.get('players_number')
    
    min_position = this.get('min_position')
    max_position = this.get('max_position')
        
    # For each column create tournament for 2 times less players
    # from (tournament min_position + column_players/2) to column max_position places
    while cur_players >= 4
#      console.log "Tournament #{this.get('min_position')}-#{this.get('max_position')}"
#      console.log "Column with #{cur_players} players, #{min_position}-#{max_position}"
#      console.log "t #{min_position + cur_players/2}-#{max_position}\n"
      new_tournament = new Kipscore.Models.Tournament
        'players_number': cur_players/2
        'max_position': max_position
        'min_position': min_position + cur_players/2
      tournaments.add new_tournament
#      console.log "Back in column with #{cur_players} players, #{min_position}-#{max_position}"
      max_position -= cur_players/2
      cur_players /= 2
      
    this.set 'related_tournaments', tournaments
  
  columnNumber: (bracket_number) ->
    return Math.floor(Math.log(bracket_number) / Math.LN2)
    
  maxColumnNumber: ->
    return Math.floor(Math.log(this.get('bracket_size')) / Math.LN2)
    
  winnerMatch: (bracket_number) ->
    return this.get('bracket').models[bracket_number/2]
  
  loserMatch: (bracket_number) ->
    tournament = this.get('related_tournaments').models[columnNumber(bracket_number)]
    return tournament.get('bracket').models[bracket_number/2]
  
    
