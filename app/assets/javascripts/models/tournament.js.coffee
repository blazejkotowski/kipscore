class Kipscore.Models.Tournament extends Backbone.RelationalModel

  url: window.location.pathname  
  
  defaults:
    'players_number': 0
    'bracket_size': 0
    'max_position': 0
    'min_position': 0
    'saving': false
    'main_tournament': false
    'admin': false
    'new': false
  
  relations: [
    { 
      key: 'results'
      type: Backbone.HasOne
      includeInJSON: false
      relatedModel: 'Kipscore.Models.Results'
      reverseRelation:
        key: 'tournament'
        includeInJSON: false
        type: Backbone.HasOne
    },
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
      reverseRelation:
        key: 'parent_tournament'
        type: Backbone.HasOne
    }
  ]
  
  initialize: ->
    if @get('main_tournament') and @get('results') is null
      results = new Kipscore.Models.Results({ 'url': @resultsUrl(), 'admin': @get('admin') })
      @set 'results', results
    
    if @isNew()
      @initNew()
      context = this
      setTimeout((-> context.mainTournament().setSaving()), 2000)
      
    # Set bracket tournament variable to actual tournament
    @get('bracket').tournament = this
    
    @on "to_save", ->
      # Do not save more than 1 time per second
      @setSaving()
      
    # Do not save on beginning
    context = this
    setTimeout((-> context.mainTournament().set('saving', 0)), 2000)
  
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
      
    # Perform empty tournaments for next tours  
    @createRelatedTournaments()    
    
    @set 'new', false
          
  # Sets saving flag for ms miliseconds
  setSaving: (ms=1000) ->
    #console.log "trying to save"
    unless @saving()
      if @get('main_tournament') and @get('admin')
        @blockSaving()
        context = this
        setTimeout((-> Window.tournament.save()), ms)
  
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
        'new': @get('new')
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
    if bracket_number == 1
      return false
    bracket = this.get('bracket')
    bracket.at (Math.floor(bracket_number/2)-1)
  
  loserMatch: (bracket_number) ->
    if bracket_number == 1
      return false
    tournament = this.get('related_tournaments').at(this.columnNumber(bracket_number))
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
      match = tournament.get('bracket').at match_index
      console.log "picked tournament", tournament
      console.log "found match", match
      match
      
      
  mainTournament: ->
    main_tournament = this
    while main_tournament.get('parent_tournament') isnt null
      main_tournament = main_tournament.get('parent_tournament')
    main_tournament
    
  saving: ->
    @mainTournament().get('saving')
  
  blockSaving: ->
    @mainTournament().set('saving', true)
    
  releaseSaving: ->
    @mainTournament().set('saving', false)
    
  isNew: ->
    @get('new')
    
  save: (callback) ->
    #console.log "saving"
    if callback is undefined
      callback = @releaseSaving
    $.ajax
      type: 'put'
      url: @url
      data:
        json_bracket: JSON.stringify(@toJSON())
      complete:
        _.bind(callback, this)
#    else
#      console.log "Not saving"
  
  savePlayers: (callback) ->
    $.ajax
      type: 'put'
      url: @url
      data:
        json_bracket: JSON.stringify({players: @get('players').toJSON(), 'new': true})
      complete:
        _.bind(callback, this)
  
  resultsUrl: ->
    parts = window.location.pathname.split('/')
    parts.slice(0,parts.length-1).join('/')+'/results'
      
Kipscore.Models.Tournament.setup()
