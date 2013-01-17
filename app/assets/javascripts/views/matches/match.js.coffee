class Kipscore.Views.Match extends Backbone.View

  tagName: 'div'
  className: ->
    if @model.ready()
      'match'
    else
      'match empty'
  template: JST['matches/match']
  
  initialize: ->
    this.render()
  
  render: ->
    $(@el).html('')
        
    player1_view = new Kipscore.Views.Player({ model: @model.get('player1') })
    $(@el).append(player1_view.render().$el)
    
    player2_view = new Kipscore.Views.Player({ model: @model.get('player2') })
    $(@el).append(player2_view.render().$el)
    
    this
