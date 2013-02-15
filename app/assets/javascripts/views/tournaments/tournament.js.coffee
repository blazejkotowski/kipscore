class Kipscore.Views.Tournament extends Backbone.View
  
  tagName: 'div'
  className: 'tournament-bracket-wrapper empty'    
  
  template: JST['tournaments/show']
    
  append: ->
    $(@el).appendTo("#tournament-container")
    
    # Tournament title
    $('<h3/>').addClass('tournament-title').text("#{@model.get('min_position')}-#{@model.get('max_position')}").insertBefore(@$el)
    
    # Top scroll
    $scroll_wrapper = $("<div/>").addClass("scroll-top-wrapper").insertBefore(@$el)
    $scroll_top = $("<div/>").addClass("scroll-top").appendTo($scroll_wrapper)
    bracket = @model.get('bracket')
    width_class = "columns#{@model.columnNumber(1)+1}"
    $scroll_top.addClass(width_class)
  
  render: ->
    # Wrapper to make scroll posbbile
    $wrapper = $('<div/>').addClass("tournament-bracket").appendTo($(@el))
    
    # Rendering column by column
    bracket = @model.get('bracket')
    
    # Proper widths
    width_class = "columns#{@model.columnNumber(1)+1}"
    $wrapper.addClass(width_class)
    
    i = bracket.length-1
    while i >= 0
      # Create next column
      if @model.columnNumber(i+1) != @model.columnNumber(i+2)
        $wrapper.append(column)
        column = $('<div/>').addClass("column#{@model.columnNumber(i+1)}")
        column.append($('<div/>').addClass('round-title').text("Round #{@model.columnNumber(i+1)+1}"))
      
      match_view = new Kipscore.Views.Match({ model: bracket.at(i) })

      # Display bracket if not empty
      unless bracket.at(i).empty()
        @$el.removeClass('empty')
      $(column).append(match_view.render().$el)
      --i
      
    $wrapper.append(column).append($('<div/>').addClass('clearfix'))
    @append()
    
    # Render related tournaments recursivly
    rt = @model.get('related_tournaments')
    rt.each (t) ->
      tv = new Kipscore.Views.Tournament({ model: t })
      tv.render()
    
    this
