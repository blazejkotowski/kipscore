class Kipscore.Models.Tournament extends Backbone.Model
  defaults:
    'bracket': {}
    'next_tours': {}
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
  
    
