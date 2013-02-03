class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    @players = new Kipscore.Collections.Players() # they are fetched now
    @players.fetch
      complete: _.bind(@drawBracket, this)

    
  drawBracket: ->
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
    tournament = new Kipscore.Models.Tournament( { 'players_number': @players.size(), 'bracket': matches } )
    Window.tournament = tournament
    
    # Displaying bracket
    tournament_view = new Kipscore.Views.Tournament({ model: tournament })
    tournament_view.render()
    
