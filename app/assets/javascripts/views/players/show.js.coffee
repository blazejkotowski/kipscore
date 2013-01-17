class Kipscore.Views.Player extends Backbone.View

  tagName: 'div'
  className: "player"
  template: JST['players/show']
  
  render: ->
    $(@el).html(@template(this.model.toJSON()))
    this
