class Kipscore.Models.BracketTournament extends Kipscore.Models.Tournament
  
  defaults: _.extend(this.__super__.defaults,
  {
    'bracket_size': 0
    'max_position': 0
    'min_position': 0
    'main_tournament': false
  })
  
  relations: Kipscore.Models.Tournament.prototype.relations.concat([
    {
      key: 'bracket'
      type: Backbone.HasMany
      relatedModel: 'Kipscore.Models.BracketMatch'
      reverseRelation:
        key: 'tournament'
        type: Backbone.HasOne
    },
    {
      key: 'related_tournaments'
      type: Backbone.HasMany
      relatedModel: "Kipscore.Models.BracketTournament"
      reverseRelation:
        key: 'parent_tournament'
        type: Backbone.HasOne
    }
  ])
  
  initialize: ->
    super()   
    # Set bracket tournament variable to actual tournament
    @get('bracket').tournament = this
  
  initNew: ->
    power = 1
    while power < @get('players_number')
      power *= 2
    
    @set 'players_number', power
    @set 'bracket_size', 2*(power/2)-1
    if @get('max_position') == 0
      @set 'max_position', power
      @set 'min_position', 1 
    
    bracket_size = @get 'bracket_size'
    bracket = @get 'bracket'
    
    # Create empty bracket if not provided
    if bracket is undefined
      matches = new Kipscore.Collections.BracketMatches()
      iter = @get 'bracket_size'
      while iter > 0
        new_match = new Kipscore.Models.BracketMatch()
        matches.add new_match
        iter--
      bracket = matches
      @set 'bracket', matches
      
    # Add next (blank) matches
    while bracket.length < bracket_size
      match = new Kipscore.Models.BracketMatch()
      bracket.add match, { at: 0 }
      
    # Perform empty tournaments for next tours  
    @createRelatedTournaments()    
    
    super()
          
  # Creates losers tournaments
  createRelatedTournaments: ->
    tournaments = new Kipscore.Collections.Tournaments()
    
    cur_players = @get('players_number')
    
    min_position = @get('min_position')
    max_position = @get('max_position')
        
    # For each column create tournament for 2 times less players
    # from (tournament min_position + column_players/2) to column max_position places
    while cur_players >= 4
      new_tournament = new Kipscore.Models.BracketTournament
        'players_number': cur_players/2
        'max_position': max_position
        'min_position': min_position + cur_players/2
        'new': @get('new')
      tournaments.add new_tournament
      max_position -= cur_players/2
      cur_players /= 2
      
    @set 'related_tournaments', tournaments
  
  columnNumber: (bracket_number) ->
    log2 = (x) ->
      Math.floor(Math.log(x) / Math.LN2)
    log2(@get('bracket_size')) - log2(bracket_number)
    
  maxColumnNumber: ->
    Math.floor(Math.log(@get('bracket_size')) / Math.LN2)
    
  winnerMatch: (bracket_number) ->
    if bracket_number == 1
      return false
    bracket = @get('bracket')
    bracket.at (Math.floor(bracket_number/2)-1)
  
  loserMatch: (bracket_number) ->
    if bracket_number == 1
      return false
    tournament = @get('related_tournaments').at(@columnNumber(bracket_number))
    bracket = tournament.get('bracket')
    bracket.at (Math.floor(bracket_number/2)-1)
    
  previousMatch: (bracket_number, number) ->
    bracket = @get('bracket')

    # Get number of match in bracket
    match_index = bracket_number*2
    if number == 'second'
      match_index = bracket_number*2 - 1 
    
    # Pick proper tournament
    tournament = @ 
    if match_index >= @get('bracket_size')
      tournament = @get('parent_tournament')
    
    unless tournament is null
      tournament.get('bracket').at match_index
      
  isMain: ->
    @get('min_position') == 1
    
Kipscore.Models.BracketTournament.setup()
