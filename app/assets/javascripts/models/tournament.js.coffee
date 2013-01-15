class Kipscore.Models.Tournament extends Backbone.Model
  defaults:
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
    if this.get('bracket') is undefined 
      this.set 'bracket', new Kipscore.Collections.Matches()
    this.createRelatedTournaments()
      
  createRelatedTournaments: ->
    tournaments = new Kipscore.Collections.Tournaments()
    x = 1
    i = 0
    while x*2 <= this.get('bracket_size')
      new_tournament = new Kipscore.Models.Tournament { 'players_number': x }
      tournaments.add new_tournament
      x *= 2
    this.set 'related_tournaments', tournaments
  
  getColumnNumber: (bracket_number) ->
    return Math.floor(Math.log(bracket_number) / Math.LN2)
  
    
