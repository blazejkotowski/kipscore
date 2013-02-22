class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    @tournament = new Kipscore.Models.Tournament({ main_tournament: true })
    @tournament.fetch
      complete: _.bind(@drawBracket, this)

    
  drawBracket: ->
    if @tournament.isNew()
      @initTournament()

    Window.tournament = @tournament
    # Displaying bracket
    tournament_view = new Kipscore.Views.Tournament({ model: @tournament })
    tournament_view.render()
    results_view = new Kipscore.Views.Results({ model: @tournament.get('results') })
    $('#tournament-container').after(results_view.render().el).after('<div class="clearfix"></div>')
  
  initTournament: ->
    #console.log "New tournament"
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
    @tournament.set { 'min_position': 0, 'max_position':0, 'players_number': @players.size(), 'bracket': matches, 'new': true }
    @tournament.initNew()
    
    for match in @tournament.get('bracket').models
      if match.pickWinner()
        match.setNextMatches()      
    
  
    
