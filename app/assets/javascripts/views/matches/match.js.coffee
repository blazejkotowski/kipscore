class Kipscore.Views.Match extends Backbone.View

  tagName: 'div'
  className: ->
    if @model.ready()
      'match'
    else
      'match empty'
  template: JST['matches/match']
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @render()
    
  events:
    'click': 'alertId'
    
  alertId: ->
    wmatch = @model.winnerMatch()
    lmatch = @model.loserMatch()
    
    console.log "you clicked match id #{@model.index()}"
   
    console.log "winner match is #{wmatch.index()} in tournament #{wmatch.collection.tournament.get('min_position')}-#{wmatch.collection.tournament.get('max_position')}"
    
    console.log "loser match is #{lmatch.index()} in tournament #{lmatch.collection.tournament.get('min_position')}-#{lmatch.collection.tournament.get('max_position')}"
    
  
  render: ->
    $(@el).html('')
        
    player1_view = new Kipscore.Views.Player({ model: @model.get('player1') })
    $(@el).append(player1_view.render().$el)
    
    player2_view = new Kipscore.Views.Player({ model: @model.get('player2') })
    $(@el).append(player2_view.render().$el)
    
    this
