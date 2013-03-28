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
    'hover': 'addButton'
    'keyup input': 'keyUp'
    'mouseleave': 'removeButton'
    'click .add_scores': 'addScores'
    
  removeButton: ->
    unless @$el.hasClass('active')
      @$el.find('.add_scores').hide()
      @$el.find('.connector').show()
  
  addButton: ->
    if @model.get('tournament').get('admin')
      @$el.find('.connector').hide()
      @$el.find('.add_scores').show()
  
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
    @renderScores()
    this
    
  renderScores: ->
    $s1 = $('<div/>').addClass('scores-table')
    $s2 = $('<div/>').addClass('scores-table')
    for scores in @model.get('scores')
      $s1.append($('<div/>').text(scores[0]))
      $s2.append($('<div/>').text(scores[1]))
    @$el.find('.scores').prepend($s1)
    @$el.find('.scores').append($s2)
