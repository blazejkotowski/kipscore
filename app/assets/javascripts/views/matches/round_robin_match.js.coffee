class Kipscore.Views.RoundRobinMatch extends Backbone.View
  tagName: 'tr'
  className: 'round-robin-match'
  
  template: JST['matches/round_robin_match']
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change:player1 change:player2 change:finished", @render
    @render()
  
  events:
    'focus input': -> @$el.addClass "active"
    'blur input': -> @$el.removeClass 'active'
    'keyup input': 'keyUp'
    'click .add_scores': 'addScores'
    
  addScores: (e) ->
    e.preventDefault()
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
    
  keyUp: (e) -> 
    @addScores(e) if e.keyCode == 13
    
  render: ->
    p1 = new Kipscore.Views.Player({ model: @model.get('player1') })
    p2 = new Kipscore.Views.Player({ model: @model.get('player2') })
    data = _.extend(@model.toJSON(), { p1v: p1, p2v: p2, admin: @model.get('tournament').get('admin') })
    @$el.html(@template(data))
    if @model.human()
      console.log "Rendering scores"
      @renderScores()
    this
    
  renderScores: ->
    $scores = $('<div/>').addClass('scores-table')
    for scores in @model.get('scores')
      $scores.append $('<div/>').text("#{scores[0]}-#{scores[1]}")
    console.log $scores, "andrzej"
    @$el.find('.scores').append($scores)
