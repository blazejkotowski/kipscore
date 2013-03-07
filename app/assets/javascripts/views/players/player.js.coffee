class Kipscore.Views.Player extends Backbone.View

  tagName: 'div'
  className: ->
    if @model.get('winner')
      "player winner"
    else
      "player"
      
  template: JST['players/player']
  
  events:
    "click": -> console.log @model
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change", @render
  
  render: ->
    $(@el).html(@template(this.model.toJSON()))
    
    this
