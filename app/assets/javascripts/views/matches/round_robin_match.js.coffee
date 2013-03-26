class Kipscore.Views.RoundRobinMatch extends Backbone.View
  tagName: 'tr'
  className: 'match'
  
  template: JST['matches/round_robin_match']
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change:player1 change:player2 change:finished", @render
    @render()
    
  render: ->
    @$el.html('')
    p1 = new Kipscore.Views.Player({ model: @model.get('player1') })
    p2 = new Kipscore.Views.Player({ model: @model.get('player2') })
    @$el.append($("<td/>").html(p1.render().$el))
    @$el.append($("<td/>").addClass("versus").text("vs"))
    @$el.append($("<td/>").html(p2.render().$el))
    this
