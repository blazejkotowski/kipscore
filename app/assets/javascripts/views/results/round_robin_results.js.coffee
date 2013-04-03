class Kipscore.Views.RoundRobinResults extends Backbone.View

  tagName: 'table'
  className: 'table results table-striped'
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change:ready", @render
    @render()
    
  render: ->
    @$el.html('')
    if @model.get('ready')
      players = @model.get('players')
      if players.length > 0
        $thead = $('<thead/>')
        $thead.append('<tr><th>Place</th><th>Name</th><th>Points</th><th>Rank</th></tr>')
        @$el.append($thead)
        $tbody = $('<tbody/>')
        
        index=0
        while index < players.length
          result = players.at(index)
          $result = $('<tr/>')
          $result.append($('<td/>').text(index+1))
          $result.append($('<td/>').text(result.get('name')))
          rank = result.get('rank')
          rank = '' if rank < 1
          $result.append($('<td/>').text(rank))
          $tbody.append($result)
          index++
    
        @$el.append($tbody)
    
    this
