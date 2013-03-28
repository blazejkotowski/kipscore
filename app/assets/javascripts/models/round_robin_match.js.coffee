class Kipscore.Models.RoundRobinMatch extends Kipscore.Models.Match
  
  defaults: _.extend(Kipscore.Models.Match.prototype.defaults, {
  })
  
  initialize: ->
    super()
    
  tournament: ->
    @get('tournament')
  
      
