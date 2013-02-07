class Kipscore.Models.Match extends Backbone.Model
  defaults:
    'player1': undefined
    'player2': undefined
    'winner': 0
    'scores': [] #[[p1,p2],[p1,p2]...]
  
  initialize: ->
    # Create empty players if not provided
    if @get('player1') is undefined
      @set 'player1', new Kipscore.Models.Player()
    if @get('player2') is undefined
      @set 'player2', new Kipscore.Models.Player()
      
    
  pickWinner: ->
    res1 = res2 = 0
    for [s1,s2] in @get('scores')
      if s1 > s2
        res1 += 1
      else
        res2 += 1
    
    if res1 > res2
      @set 'winner', @get('player1')
    else
      @set 'winner', @get('player2')
    
    @get 'winner'
    
  addScores: (p1,p2) ->
    @get('scores').push([p1,p2])
    this
      
  addPlayer: (player) ->
    if @get('player2').empty()
      @set 'player2', player
      true
    else if this.get('player1').empty()
      @set 'player1', player
      true
    else
      false
  
  ready: ->
    player1 = @get('player1')
    player2 = @get('player2')
    not(player1.empty() or player2.empty())
    
  winnerMatch: ->
    return @collection.tournament.winnerMatch(this.index())
    
  loserMatch: ->
    return @collection.tournament.loserMatch(this.index())
    
  index: ->
    try
      return @collection.indexOf(this)+1
    catch error
      return -1
