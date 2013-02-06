class Kipscore.Models.Match extends Backbone.Model
  defaults:
    'player1': undefined
    'player2': undefined
    'winner': 0
    'score1': 0
    'score2': 0
  
  initialize: ->
    # Create empty players if not provided
    if this.get('player1') is undefined
      this.set 'player1', new Kipscore.Models.Player()
    if this.get('player2') is undefined
      this.set 'player2', new Kipscore.Models.Player()
    
  pickWinner: ->
    if this.get 'score1' > this.get 'score2'
      this.set 'winner', this.get 'player1'
    else
      this.set 'winner', this.get 'player2'
      
  addPlayer: (player) ->
    if this.get('player2').empty()
      this.set 'player2', player
      return true
    else if this.get('player1').empty()
      this.set 'player1', player
      return true
    else
      return false
  
  ready: ->
    player1 = this.get('player1')
    player2 = this.get('player2')
    return not(player1.empty() or player2.empty())
    
  winnerMatch: ->
    return this.collection.tournament.winnerMatch(this.index())
    
  loserMatch: ->
    return this.collection.tournament.loserMatch(this.index())
    
  index: ->
    try
      return this.collection.indexOf(this)+1
    catch error
      return -1
