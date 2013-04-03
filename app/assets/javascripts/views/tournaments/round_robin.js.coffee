class Kipscore.Views.RoundRobinTournament extends Backbone.View
  
  tagName: 'div'
  className: 'round-robin-wrapper'    
  
  template: JST['tournaments/round_robin']
  
  render: ->
    iter = 1
    for round in @model.get('rounds')
      $round = $(JST['tournaments/round_robin_round']({number: iter++}))
      for match in round.models
        mv = new Kipscore.Views.RoundRobinMatch({model: match})
        $round.append(mv.render().$el)
      @$el.append($round)
      
    this
  
