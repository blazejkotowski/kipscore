class Kipscore.Models.Player extends Backbone.RelationalModel
  defaults:
    'name': undefined
    'start_position': 0
    'rank': -1
    'empty': false
    'bye': false
    
  initialize: ->
    if this.get('name') is undefined
      this.set({ 'name': '', 'empty': true })
  
  empty: ->
    return this.get('empty')
