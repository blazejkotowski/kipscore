class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    @tournament = new Kipscore.Models.Tournament()
    @tournament.fetch
      complete: _.bind(@drawBracket, this)

    
  drawBracket: ->
    @players = @tournament.get('players')
    matches = new Kipscore.Collections.Matches()
    i = 0
    match = new Kipscore.Models.Match()
    while i < @players.size()
      match.addPlayer(@players.at(i))
      if match.ready()
        matches.add match
        match = new Kipscore.Models.Match()
      i++
      
    # Create tournament from matches
    @tournament.set {'players_number': @players.size(), 'bracket': matches }
    @tournament.initialize()
    Window.tournament = @tournament
    
    # Displaying bracket
    tournament_view = new Kipscore.Views.Tournament({ model: @tournament })
    for match in @tournament.get('bracket').models
      if match.pickWinner()
        match.setNextMatches()      
    console.log "chuj"
    tournament_view.render()
  
    
