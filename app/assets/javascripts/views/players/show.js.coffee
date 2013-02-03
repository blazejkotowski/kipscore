class Kipscore.Views.Player extends Backbone.View

  tagName: 'div'
  className: "player"
  template: JST['players/show']
  
  initialize: ->
    # render on change
    _.bindAll(this, "render")
    @model.bind "change", @render
  
  render: ->
    $(@el).html(@template(this.model.toJSON()))
    this
