class Kipscore.Views.Tournament extends Backbone.View
  
  tagName: 'div'
  className: 'tournament-bracket'    
  
  template: JST['tournaments/show']
  
  append: ->
    $(@el).appendTo("#main-container")
  
  render: ->
    $(@el).html('')
    $(@el).append($('<h2/>').addClass('torunament-title').text("Tournament #{@model.get('min_position')}-#{@model.get('max_position')}"))
    bracket = @model.get('bracket')
    i = bracket.length-1
    while i >= 0
      # Create next column
      if @model.columnNumber(i+1) != @model.columnNumber(i+2)
        $(@el).append(column)
        column = $('<div/>').addClass("column#{@model.maxColumnNumber()-@model.columnNumber(i+1)}")
        column.append($('<h3/>').addClass('round-title').text("Round #{@model.maxColumnNumber()-@model.columnNumber(i+1)+1}"))
      
      match_view = new Kipscore.Views.Match({ model: bracket.at(i) })
      $(column).append(match_view.render().$el)
      --i
      
    $(@el).append(column).append($('<div/>').addClass('clearfix'))
    @append()
    
    # Render related tournaments recursivly
    rt = @model.get('related_tournaments')
    rt.each (t) ->
      tv = new Kipscore.Views.Tournament({ model: t })
      $('#main-container').append(tv.render())
    
    this
