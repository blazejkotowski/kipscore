class Kipscore.Models.Match extends Backbone.Model
  defaults:
    'player1': undefined
    'player2': undefined
    'winner': undefined
    'loser': undefined
    'finished': false
    'scores': undefined #[[p1,p2],[p1,p2]...]
  
  initialize: ->
    # Create empty players if not provided
    if @get('player1') is undefined
      @set 'player1', new Kipscore.Models.Player()
    if @get('player2') is undefined
      @set 'player2', new Kipscore.Models.Player()
    
    @set 'scores', new Array()
      
  pickWinner: ->
    # Match with bye case
    if @get('player1').get('bye') && not @get('player2').get('bye')
      @set 'winner', @get('player2')
      @set 'loser', @get('player2')
      return true
    if @get('player2').get('bye') && not @get('player1').get('bye')
      @set 'winner', @get('player1')
      @set 'loser', @get('player2')
      return true
    
    # Counting set points
    res1 = res2 = 0
    for [s1,s2] in @get('scores')
      if s1 > s2
        res1 += 1
      else if s2 > s1
        res2 += 1
    
    # Player1 win
    if res1 > res2
      @set 'winner', @get('player1')
      @set 'loser', @get('player2')
      true
    # Player2 win
    else if res2 > res1
      @set 'winner', @get('player2')
      @set 'loser', @get('player1')
      true
    # Draw
    else
      false
  
  setNextMatches: ->
    if @get 'finished'
      return false
      
    wmatch = @winnerMatch()
    lmatch = @loserMatch()
    
    wmatch.addPlayer @get('winner')
    lmatch.addPlayer @get('loser')
    
    @set 'finished', true
    
    return true
    
    
  addScores: (p1,p2) ->
    @get('scores').push([parseInt(p1),parseInt(p2)])
    this
      
  addPlayer: (player) ->
    if @get('player2').empty()
      @set 'player2', player
      true
    else if @get('player1').empty()
      @set 'player1', player
      true
    else
      false
  
  ready: ->
    player1 = @get('player1')
    player2 = @get('player2')
    not(player1.empty() or player2.empty())
    
  winnerMatch: ->
    @collection.tournament.winnerMatch(@index())
    
  loserMatch: ->
    @collection.tournament.loserMatch(@index())
    
  index: ->
    try
      return @collection.indexOf(this)+1
    catch error
      return -1
