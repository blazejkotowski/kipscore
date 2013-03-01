class Kipscore.Views.PlayerItem extends Backbone.View

  tagName: 'li'
  className: ->
    unless @model.get('bye')
      "player group#{@model.get('label_id')}"
    else
      "player"
  template: JST['players/player_item']
  
  initialize: ->
    # render on change
    _.bindAll(this, "render")
    @model.bind "change", @render
  
  render: ->
    $(@el).html(@template(this.model.toJSON()))
    if @options.draggable
      model = @model
      @$el.draggable
        helper: 'clone'
        start: (ev, ui) ->
          window.draggable = model
        stop: ->
          # Swap model attributes without start_position
          if window.draggable && window.droppable
            # l1 = window.draggable.get('label')
            # l2 = window.droppable.get('label')
            # if l1 == l2
            if true
              droppable_attrs = _.clone(window.droppable.attributes)
              draggable_attrs = _.clone(window.draggable.attributes)
              delete droppable_attrs.start_position
              delete draggable_attrs.start_position
              window.draggable.set(droppable_attrs)
              window.droppable.set(draggable_attrs)
            # else
            #   console.log "They aren't from the same group"
          
          window.draggable = undefined
          window.droppable = undefined
          
      @$el.droppable
        drop: (ev, ui) ->
          window.droppable = model
    
    this
