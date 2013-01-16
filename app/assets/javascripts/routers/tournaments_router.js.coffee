class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    matches = new Kipscore.Collections.Matches()
    i = 1
    match = new Kipscore.Models.Match()
    while i <= 16
      player = new Kipscore.Models.Player( { 'name': "Player ##{i}" } )
      match.addPlayer(player)
      if match.ready()
        matches.add match
        match = new Kipscore.Models.Match()
      i++
    
    # Create tournament from matches
    tournament = new Kipscore.Models.Tournament( { 'players_number': 16, 'bracket': matches } )
    Window.tournament = tournament
    
    # Displaying bracket
    tournament_view = new Kipscore.Views.Tournament({ model: tournament })
    $('#main-container').prepend(tournament_view.render().$el)
    
    
