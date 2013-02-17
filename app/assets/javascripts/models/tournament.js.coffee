class Kipscore.Models.Tournament extends Backbone.RelationalModel

  url: window.location.pathname  
  
  defaults:
    'players_number': 0
    'bracket_size': 0
    'max_position': 0
    'min_position': 0
    'saving': 1
    'main_tournament': false
  
  relations: [
    {
      key: 'players'
      type: Backbone.HasMany
      relatedModel: 'Kipscore.Models.Player'
    },
    {
      key: 'bracket'
      type: Backbone.HasMany
      relatedModel: 'Kipscore.Models.Match'
      reverseRelation:
        key: 'tournament'
        type: Backbone.HasOne
    },
    {
      key: 'related_tournaments'
      type: Backbone.HasMany
      relatedModel: "Kipscore.Models.Tournament"
    }
  ]
  
  initialize: ->
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
      matches = new Kipscore.Collections.Matches()
      iter = @get 'bracket_size'
      while iter > 0
        new_match = new Kipscore.Models.Match()
        matches.add new_match
        iter--
      bracket = matches
      @set 'bracket', matches
    
    # Add next (blank) matches
    while bracket.length < bracket_size
      match = new Kipscore.Models.Match()
      bracket.add match, { at: 0 }
      
    # Set bracket tournament variable to actual tournament
    bracket.tournament = this
    
    # Perform empty tournaments for next tours  
    @createRelatedTournaments()
    
    @on "to_save", ->
      # Do not save more than 1 time per second
      @setSaving()
    
    # Do not save on beginning
    context = this
    setTimeout((-> context.set('save', 0)), 2000)
          
  # Sets saving flag for ms miliseconds
  setSaving: (ms=1000) ->
    @set 'saving', 1
    context = this
    setTimeout((-> context.save()), ms)
  
  # Creates losers tournaments
  createRelatedTournaments: ->
    tournaments = new Kipscore.Collections.Tournaments()
    
    cur_players = this.get('players_number')
    
    min_position = this.get('min_position')
    max_position = this.get('max_position')
        
    # For each column create tournament for 2 times less players
    # from (tournament min_position + column_players/2) to column max_position places
    while cur_players >= 4
      new_tournament = new Kipscore.Models.Tournament
        'players_number': cur_players/2
        'max_position': max_position
        'min_position': min_position + cur_players/2
      tournaments.add new_tournament
      max_position -= cur_players/2
      cur_players /= 2
      
    this.set 'related_tournaments', tournaments
  
  columnNumber: (bracket_number) ->
    log2 = (x) ->
      Math.floor(Math.log(x) / Math.LN2)
    log2(this.get('bracket_size')) - log2(bracket_number)
    
  maxColumnNumber: ->
    return Math.floor(Math.log(this.get('bracket_size')) / Math.LN2)
    
  winnerMatch: (bracket_number) ->
    bracket = this.get('bracket')
    bracket.at (Math.floor(bracket_number/2)-1)
  
  loserMatch: (bracket_number) ->
    tournament = this.get('related_tournaments').at(this.columnNumber(bracket_number))
    bracket = tournament.get('bracket')
    bracket.at (Math.floor(bracket_number/2)-1)
    
    
  isNew: ->
    @get('bracket').length < 1
    
  save: ->
    if !@isNew() and @get('main_tournament')
      $.ajax
        type: 'put'
        url: @url
        data:
          json_bracket: JSON.stringify(@toJSON())
        complete:
          @set 'saving', 0
