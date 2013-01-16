class Kipscore.Views.Tournament extends Backbone.View
  
  tagName: 'div'
  className: 'tournament-bracket'    
  
  template: JST['tournaments/show']
  
  render: ->
    $(@el).html('')
    bracket = this.model.get('bracket')
    i = bracket.length-1
    column = $('<div/>').addClass('column')
    while i >= 0
      # Create next column
      if this.model.columnNumber(i+1) != this.model.columnNumber(i+2)
        $(@el).append(column)
        column = $('<div/>').addClass('column')
      
      match_view = new Kipscore.Views.Match({ model: bracket.at(i) })
      $(column).append(match_view.render().$el)
      --i
      
    $(@el).append(column).append($('<div/>').addClass('clearfix'))
    
    # Render related tournaments recursivly
    rt = this.model.get('related_tournaments')
    rt.each (t) ->
      console.log t.get('bracket')
      tv = new Kipscore.Views.Tournament({ model: t })
      $('#main-container').append(tv.render().$el)
    
    this
