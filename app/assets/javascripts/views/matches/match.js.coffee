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
    'click .new': 'newScore'
    'keyup .player_score': 'keyup'
    'click a.proceed': 'proceedMatch'
  
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
        
  proceedMatch: (event) ->
    if event isnt undefined
      event.preventDefault()
    
    if @model.pickWinner()
      if @model.setNextMatches()
        true
      else
        alert "Match is already finished!"
        false
    else
      if event isnt undefined
        alert ("It's draw!")
        false
      
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
    
