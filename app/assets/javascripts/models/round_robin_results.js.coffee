class Kipscore.Models.RoundRobinResults extends Kipscore.Models.Results
  
  defaults: _.extend(Kipscore.Models.Results.prototype.defaults, {
    ready: false,
  })
  
  add: (player, points) ->
    if player is null || player.bye()
      return false
    list = @get('players')
    for p in list.models
      if player.get('name') == p.get('name')
        p.set 'points', p.get('points') + points
        console.log p.get('points')
        
  sumResults: ->
    tournament = @get('tournament')
    rounds = tournament.get('rounds')
    Window.rounds = rounds
    context = this
    _.each rounds, (round, index) ->
      _.each round.models, (match, index) ->
        match.pickWinner()
        if match.human()
          context.add match.get('winner'), tournament.get('win_points') + tournament.get('base_points')
          context.add match.get('loser'), tournament.get('loss_points') + tournament.get('base_points')
      
  pickPlaces: ->  
    list = @get('players')
    unsorted_list = _.map list.models, (player, iter)->
      [iter, if player.human() then player.get('points') else -1]
    
    sorted_list = _.sortBy unsorted_list, (tab) -> 
      -tab[1]
    sorted_list
    
    new_list = []
    i = 0
    for place in sorted_list
      new_list[i++] = list.models[place[0]]
    
    @get('players').models = new_list
    
  
  setResults: ->
    @sumResults()
    @pickPlaces()
    @set 'ready', true
    @trigger 'change:ready'
      
  fillResults: ->
    @set 'players', @get('tournament').get('players')    
    @trigger "to_save"
    return true
