class Kipscore.Models.RoundRobinTournament extends Kipscore.Models.Tournament
  defaults: _.extend(Kipscore.Models.Tournament.prototype.defaults, {
    
  })
  
  initialize: ->
    super()
    
  initNew: ->
    console.log "New tournment!"
    rounds = []
    rounds_array = @get('rounds')
    for round_array in rounds_array
      round = new Kipscore.Collections.RoundRobinMatches()
      i = 0
      for match in round_array
        p1 = new Kipscore.Models.Player(match[0])
        p2 = new Kipscore.Models.Player(match[1])
        match = new Kipscore.Models.RoundRobinMatch({ tournament: @ })
        match.addPlayer p1
        match.addPlayer p2
        round.add match
      rounds[rounds.length] = round
    @set('rounds', rounds)
    super()
        
  
Kipscore.Models.RoundRobinTournament.setup()
