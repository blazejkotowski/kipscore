class Kipscore.Views.Players extends Backbone.View
  
  tagName: 'ol'
  
  initialize: ->
    _.bindAll(this, "render")
  
  render: ->
    @$el.html('')
    context = @
    _.each @model.models, (player, index, collection) ->
      player_view = new Kipscore.Views.PlayerItem({ model: player, draggable: context.options.draggable })
      player_view.$el.attr('data-label', player.get('label'))
      context.$el.append(player_view.render().$el)
      
    this
