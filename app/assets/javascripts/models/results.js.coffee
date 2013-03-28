class Kipscore.Models.Results extends Backbone.RelationalModel
  url: '/'
  
  defaults:
    'places_number': 0
  
  relations: [
    {
      key: 'players'
      type: Backbone.HasMany
      relatedModel: 'Kipscore.Models.Player'
    }
  ]
  
  initialize: (attrs) ->
    @fetch
      complete: _.bind(@fillResults, this)
      
    @on "to_save", ->
      @setSaving()
    
    context = this  
    setTimeout((-> context.set('saving', false)), 1000)
  
  admin: -> 
    if @get('tournament') isnt null
      @get('tournament').get('admin')
    else
      false
  
  setSaving: (ms=1000) ->
    unless @saving()
      @blockSaving()
      context = this
      setTimeout((-> context.save(context)), ms)
      
  saving: ->  
    @get 'saving'
    
  blockSaving: ->
    @set 'saving', true
    
  releaseSaving: ->
    @set 'saving', false
    
  save: ->
    if @admin()
      $.ajax
        type: 'put'
        url: @url
        data:
          json_results: JSON.stringify(@toJSON())
        complete:
          _.bind(@releaseSaving,this)
  
  fillResults: ->
    if @get('players').length > 0
      return false
    
    players = @get('players')      
    n = @get('places_number')
        
    while n > 0
      players.add new Kipscore.Models.Player()
      n--
    
    @trigger "to_save"
    return true

  add: (place, player) ->
    list = @get('players')
    
    unless list.at(place-1).empty()
      return false
    
    list.at(place-1).set(player.toJSON())
    
    @trigger "to_save"

Kipscore.Models.Results.setup()
