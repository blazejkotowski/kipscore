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
    'click .new': 'newScore'
    'keyup .player_score': 'keyup'
  
  newScore: (event) ->
    event.preventDefault()
    
    filled = true
    scores = []
    @$el.find('input.player_score').each (i, obj) ->
      if $(obj).val() == ''
        filled = false
        alert 'You have to fill both scores'
        return false
      
      scores[i] = $(obj).val()
  
    if filled
      @model.addScores(scores[0], scores[1])
      @render()
      @$el.find('.player_score').first().focus()
      
  
  keyup: (event) ->
    @newScore(event) if event.keyCode==13
        
    
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
    
    scores = @scores()
    
    $(@el).append(scores)
    
    proceed_link = $("<a/>").addClass("proceed").attr("href", "#").append($("<i/>").addClass("icon-chevron-right"))
    proceed_button = $("<div/>").addClass("proceed-button").append(proceed_link)
    
    @$el.append(proceed_button)
    
    
    this
    
  scores: ->
    scores_div = $('<div/>').addClass('scores')
    
    table = $('<table/>').appendTo(scores_div)
    body = $('<tbody/>').appendTo(table)
    scores = @model.get('scores')
    for i in [0,1]
      row = $('<tr/>').appendTo(body)
      for score in scores
        row.append($('<td/>').text(score[i]))
      row.append($('<td/>').append($('<input/>').addClass('player_score').attr('type','text')))
        
    
    new_score = $('<a/>').attr('href','#').addClass("new").append($("<i/>").addClass("icon-plus")).appendTo(scores_div)  
    
    scores_div
    
