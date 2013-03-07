class Kipscore.Views.Tournament extends Backbone.View
  
  tagName: 'div'
  className: 'tournament-bracket-wrapper empty'    
  
  template: JST['tournaments/show']
  
  append: ->
    $(@el).appendTo("#tournament-container")
    
    # Top scroll
    $scroll_wrapper = $("<div/>").addClass("scroll-top-wrapper empty").insertBefore(@$el)
    unless @empty is undefined
      $scroll_wrapper.removeClass("empty")
    $scroll_top = $("<div/>").addClass("scroll-top").appendTo($scroll_wrapper)
    bracket = @model.get('bracket')
    width_class = "columns#{@model.columnNumber(1)+1}"
    $scroll_top.addClass(width_class)
    
    # Tournament top scroll bind to bottom scroll
    $($scroll_wrapper).scroll (event) ->
      offset = $(event.target).scrollLeft()
      $(event.target).next(".tournament-bracket-wrapper").scrollLeft(offset)
    @$el.scroll (event) ->
      offset = $(event.target).scrollLeft()
      $(event.target).prev(".scroll-top-wrapper").scrollLeft(offset)    
  
  render: ->
    # Tournament title
    @$el.append($('<h3/>').addClass('tournament-title').text("#{@model.get('min_position')}-#{@model.get('max_position')}"))
    
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
        @empty = false
      $(column).append(match_view.render().$el)
      --i
      
    $wrapper.append(column).append($('<div/>').addClass('clearfix'))
    @append()
    
    # Render related tournaments recursivly
    rt = @model.get('related_tournaments')
    titer = rt.length - 1
    console.log titer
    while titer >= 0
      tv = new Kipscore.Views.Tournament({ model: rt.at(titer) })
      tv.render()
      titer--
    
    this
