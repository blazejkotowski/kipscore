class Kipscore.Views.Results extends Backbone.View
  tagName: 'table'
  className: 'table results table-striped'
  
  initialize: ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @render()
    
  render: ->
    @$el.html('')
    
    $thead = $('<thead/>')
    $thead.append('<tr><th>Place</th><th>Name</th><th>Rank</th></tr>')
    @$el.append($thead)
    $tbody = $('<tbody/>')
    @$el.append()
    
    index=0
    players = @model.get('players')
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
