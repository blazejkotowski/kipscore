class Kipscore.Models.Tournament extends Backbone.RelationalModel

  url: window.location.pathname + '.json'  
  
  defaults:
    'players_number': 0
    'saving': false
    'admin': false
    'new': false
  
  relations: [
    {
      key: 'players'
      type: Backbone.HasMany
      relatedModel: 'Kipscore.Models.Player'
    }
  ]
  
  initialize: ->
    if (@get('main_tournament') == undefined) || @get('main_tournament') and @get('results') is null
      results = new Kipscore.Models.Results({ 'url': @resultsUrl(), 'admin': @get('admin') })
      @set 'results', results
    
    if @isNew()
      @initNew()
      context = this
      setTimeout((-> context.mainTournament().setSaving()), 2000)
      
    @on "to_save", ->
      # Do not save more than 1 time per second
      @mainTournament().setSaving()
      
    # Do not save on beginning
    context = this
    setTimeout((-> context.mainTournament().set('saving', 0)), 2000)
  
  initNew: ->
    @set 'new', false
          
  # Sets saving flag for ms miliseconds
  setSaving: (ms=1000) ->
    #console.log "trying to save"
    unless @saving()
      if (@get('main_tournament') || @get('main_tournament') == undefined) and @get('admin')
        @blockSaving()
        context = this
        setTimeout((-> Window.tournament.save()), ms)
  
  mainTournament: ->
    main_tournament = this
    while main_tournament.get('parent_tournament') isnt null && main_tournament.get('parent_tournament') isnt undefined
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
    parts.slice(0,parts.length-1).join('/')+'/results.json'
      
Kipscore.Models.Tournament.setup()
