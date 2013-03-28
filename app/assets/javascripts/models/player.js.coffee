class Kipscore.Models.Player extends Backbone.RelationalModel
  defaults:
    'name': undefined
    'start_position': 0
    'rank': -1
    'empty': false
    'bye': false
    'winner': false
    'end_position': null
    'points': 0
    
  initialize: ->
    if @get('name') is undefined
      @set({ 'name': '', 'empty': true })
  
  empty: ->
    return @get('empty')
    
  bye: ->
    return @get('bye')
    
  human: ->
    return !@get('bye') && !@get('empty')
    
  clone: ->
    new Kipscore.Models.Player
      name: @get('name')
      start_position: @get("start_position")
      rank: @get("rank")
      empty: @get("empty")
      bye: @get("bye")

Kipscore.Models.Player.setup()
