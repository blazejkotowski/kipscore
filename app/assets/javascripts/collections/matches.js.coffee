class Kipscore.Collections.Matches extends Backbone.Collection

  model: Kipscore.Models.Match
  
  initialize: ->
    this.on "to_save", -> 
      @tournament.trigger('to_save')
  
