class Kipscore.Models.Match extends Backbone.Model
  defaults:
    'player1': undefined
    'player2': undefined
    'winner': 0
    'score1': 0
    'score2': 0
    
  initialize: ->
    this.set 'player1', new Kipscore.Models.Player() if this.get 'player1' is undefined
    this.set 'player2', new Kipscore.Models.Player() if this.get 'player2' is undefined
  
  pickWinner: ->
    if this.get 'score1' > this.get 'score2'
      this.set 'winner', this.get 'player1'
    else
      this.set 'winner', this.get 'player2'
    
