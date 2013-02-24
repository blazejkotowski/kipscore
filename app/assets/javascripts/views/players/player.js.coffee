class Kipscore.Views.Player extends Backbone.View

  tagName: 'div'
  className: "player"
  template: JST['players/player']
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change", @render
  
  render: ->
    $(@el).html(@template(this.model.toJSON()))
    
    this
