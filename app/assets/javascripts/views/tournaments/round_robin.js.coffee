class Kipscore.Views.RoundRobinTournament extends Backbone.View
  
  tagName: 'div'
  className: 'tournament-wrapper'    
  
  template: JST['tournaments/round_robin']
  
  render: ->
    @$el.html(@template(@model.toJSON()))
    this
  
