class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    this.players = new Kipscore.Collections.Players() # they are fetched now
    this.players.fetch
      complete: _.bind(this.drawBracket, this)

    
  drawBracket: ->
    players = this.players
    matches = new Kipscore.Collections.Matches()
    console.log players
    i = 0
    match = new Kipscore.Models.Match()
    while i < players.size()
      match.addPlayer(players.at(i))
      if match.ready()
        matches.add match
        match = new Kipscore.Models.Match()
      i++
      
    # Create tournament from matches
    tournament = new Kipscore.Models.Tournament( { 'players_number': players.size(), 'bracket': matches } )
    Window.tournament = tournament
    
    # Displaying bracket
    tournament_view = new Kipscore.Views.Tournament({ model: tournament })
    tournament_view.render()
    
