class Kipscore.Routers.RoundRobin extends Backbone.Router
  routes:
    '': 'index'
      
  index: ->
    @tournament = new Kipscore.Models.RoundRobinTournament({ main_tournament: true })
    @tournament.fetch
      complete: _.bind(@drawRounds, this)

    
  drawRounds: ->
    if @tournament.isNew()
      @tournament.initNew()
    Window.tournament = @tournament
    # Displaying bracket
    tournament_view = new Kipscore.Views.RoundRobinTournament({ model: @tournament })
    $("#tournament-container").html(tournament_view.render().$el)
    results_view = new Kipscore.Views.Results({ model: @tournament.get('results') })
    $('#tournament-container').after(results_view.render().el).after('<div class="clearfix"></div>')
    
  
    
