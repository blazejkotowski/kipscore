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
    'blur input': -> @$el.removeClass "active"
    
  render: ->
    p1 = new Kipscore.Views.Player({ model: @model.get('player1') })
    p2 = new Kipscore.Views.Player({ model: @model.get('player2') })
    data = _.extend(@model.toJSON(), { p1v: p1, p2v: p2, admin: @model.get('tournament').get('admin') })
    @$el.html(@template(data))
    this
