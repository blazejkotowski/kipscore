class Kipscore.Models.RoundRobinResults extends Kipscore.Models.Results
  
  add: (player, points) ->
    list = @get('players')
    for p in list.models
      if player.get('name') == p.get('name')
        p.set 'points', p.get('points') + points
        console.log p.get('points')
        
  pickPlaces: ->  
    list = @get('players')
    unsorted_list = _.map list.models, (player, iter)->
      [iter, if player.human() then player.get('points') else -1]
    
    sorted_list = _.sortBy unsorted_list, (tab) -> 
      -tab[1]
  
  fillResults: ->
    @set 'players', @get('tournament').get('players')    
    @trigger "to_save"
    return true
