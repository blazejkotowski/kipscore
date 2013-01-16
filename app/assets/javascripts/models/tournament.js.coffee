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
    x = 2
    i = 0
    while x*2 <= this.get('bracket_size')+1
      new_tournament = new Kipscore.Models.Tournament { 'players_number': x }
      tournaments.add new_tournament
      x *= 2
      
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
  
    
