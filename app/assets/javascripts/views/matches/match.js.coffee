class Kipscore.Views.Match extends Backbone.View

  tagName: 'div'
  className: 'match'
  template: JST['matches/match']
  
  initialize: ->
    this.render()
  
  render: ->
    $(@el).html('')
        
    player1 = this.model.get('player1')
    player1 = new Kipscore.Models.Player() if player1 == undefined
    player1_view = new Kipscore.Views.Player({ model: player1 })
    $(@el).append(player1_view.render().$el)
    
    player2 = this.model.get('player2')
    player2 = new Kipscore.Models.Player() if player2 == undefined
    player2_view = new Kipscore.Views.Player({ model: player2 })
    $(@el).append(player2_view.render().$el)
    
    this
