class Kipscore.Views.RoundRobinResults extends Backbone.View

  tagName: 'div'
  className: ''
  template: JST['results/round_robin_results']
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change:ready", @render
    @render()
    
  events: 
    'click .results-button': 'getResults'
    
  getResults: (e) ->  
    e.preventDefault()
    @model.setResults()
    
  render: ->
    @$el.html('')
    
    # Results button
    $container = $("<div/>").addClass("row align-center")
    $button = $("<button/>").addClass("btn btn-large btn-primary results-button")
              .text("Results").appendTo($container)
    
    @$el.append($container)
    
    # Results table
    if @model.get('ready')
      players = @model.get('players')
      @$el.append(@template(@model.toJSON()))

    this
