class Kipscore.Models.RoundRobinTournament extends Kipscore.Models.Tournament
  defaults: _.extend(Kipscore.Models.Tournament.prototype.defaults, {
    win_points: 0
    base_points: 0
    loss_points: 0
    draw_points: 0
  })
  
  relations: Kipscore.Models.Tournament.prototype.relations.concat([
    {
      key: 'results'
      type: Backbone.HasOne
      relatedModel: 'Kipscore.Models.RoundRobinResults'
      reverseRelation:
        key: 'tournament'
        type: Backbone.HasOne
    }
  ])
  
  initialize: ->
    super()
    
  initNew: ->
    console.log "New tournment!"
    rounds = []
    rounds_array = @get('rounds')
    i = 0
    for round_array in rounds_array
      round = new Kipscore.Collections.RoundRobinMatches()
      round.tournament = @
      for match in round_array
        p1 = new Kipscore.Models.Player(match[0])
        p2 = new Kipscore.Models.Player(match[1])
        if i == 0
          @get('players').add p1
          @get('players').add p2
          
        match = new Kipscore.Models.RoundRobinMatch({ tournament: @ })
        match.addPlayer p1,1
        match.addPlayer p2,0
        round.add match
      rounds[rounds.length] = round
      i++
    @set('rounds', rounds)
    super()
    
  save: ->
    null
        
  
Kipscore.Models.RoundRobinTournament.setup()
