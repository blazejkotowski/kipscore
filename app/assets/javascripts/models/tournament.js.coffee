class Kipscore.Models.Tournament extends Backbone.Model
  defaults:
    'bracket': new Array()
    'related_tournaments': new Array()
    'players_number': 0
    'bracket_size': 0
    'max_position': 0
    'min_position': 0
  
  initialize: ->
    power = 1
    while power < this.get('players_number')
      power *= 2
    this.set 'bracket_size', power
    if this.get('max_position') == 0
      this.set 'max_position', power
      this.set 'min_position', 1
    this.createRelatedTournaments()
      
  createRelatedTournaments: ->
    x = 1
    i = 0
    while x*2 <= this.get('bracket_size')
      new_tournament = new Kipscore.Models.Tournament { 'players_number': x }
      this.get("related_tournaments")[i++] = new_tournament
      x *= 2
  
  getColumnNumber: (bracket_number) ->
    return Math.floor(Math.log(bracket_number) / Math.LN2)
  
    
