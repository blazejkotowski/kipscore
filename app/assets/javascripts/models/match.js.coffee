class Kipscore.Models.Match extends Backbone.RelationalModel
  defaults:
    'winner': undefined
    'loser': undefined
    'finished': false
    'scores': undefined #[[p1,p2],[p1,p2]...]
    
  relations: [
    { 
      type: Backbone.HasOne
      key: 'player1'
      relatedModel: 'Kipscore.Models.Player'
    },
    {
      type: Backbone.HasOne
      key: 'player2'
      relatedModel: 'Kipscore.Models.Player'
    }
  ]
  
  initialize: ->
    # Create empty players if not provided
    if @get('player1') is null
      @set 'player1', new Kipscore.Models.Player()
    if @get('player2') is null
      @set 'player2', new Kipscore.Models.Player()
    
    @set 'scores', new Array()
    
    # Auto-pick winner (in case of bye)
    this.on "change:player1 change:player2", ->
      try
        if @pickWinner()
          @setNextMatches()
      
  pickWinner: ->
    # Not pickd if match not ready
    unless @ready()
      return false
      
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
    
  empty: ->
    return @get('player1').empty() && @get('player2').empty()
    
  winnerMatch: ->
    @collection.tournament.winnerMatch(@index())
    
  loserMatch: ->
    @collection.tournament.loserMatch(@index())
    
  index: ->
    try
      return @collection.indexOf(this)+1
    catch error
      return -1
