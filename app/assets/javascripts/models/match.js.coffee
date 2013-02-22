class Kipscore.Models.Match extends Backbone.RelationalModel
  defaults:
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
    {
      type: Backbone.HasOne
      key: 'winner'
      relatedModel: 'Kipscore.Models.Player'
    }
    {
      type: Backbone.HasOne
      key: 'loser'
      relatedModel: 'Kipscore.Models.Player'
    }
  ]
  
  initialize: ->
    # Create empty players if not provided
    if @get('player1') is null
      @set 'player1', new Kipscore.Models.Player()
    if @get('player2') is null
      @set 'player2', new Kipscore.Models.Player()
    
    @set 'scores', new Array() if @get('scores') == undefined
    
    # Auto-pick winner (in case of bye)
    @on "change:player1 change:player2", ->
      try
        if @pickWinner()
          @setNextMatches()
          
    @on "to_save", ->
      try
        @collection.tournament.trigger "to_save"
    
  pickWinner: ->
    # Not pickd if match not ready
    unless @ready() && @collection.tournament.mainTournament().get('admin')
      return false
      
    # Match with bye case
    if @get('player1').get('bye') && not @get('player2').empty()
      @set 'winner', @get('player2')
      @set 'loser', @get('player1')
      return true
    if @get('player2').get('bye') && not @get('player1').empty()
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
    
#    if @get('winner').get('bye') && @get('loser').get('bye')
#      console.log "Two byes setting"
      
    wmatch = @winnerMatch()
    lmatch = @loserMatch()
    
    unless wmatch is false
      wmatch.addPlayer @get('winner'), @index()%2 ? 1 : 2
    else
      position = @collection.tournament.get('min_position')
      console.log position
      @collection.tournament.mainTournament().get('results').add(position, @get('winner'))
    unless lmatch is false
      lmatch.addPlayer @get('loser'), @index()%2 ? 1 : 2
    else
      position = @collection.tournament.get('min_position')+1
      @collection.tournament.mainTournament().get('results').add(position, @get('loser'))
      
    @set 'finished', true
    @trigger "to_save"
    
    return true
  
  previousMatch: (player) ->
    if player == 1
      @index()*2
    else if player == 2
      @index()*2
    false
        
  addScores: (p1,p2) ->
    @get('scores').push([parseInt(p1),parseInt(p2)])
    @trigger "to_save"
    this
      
  addPlayer: (player, position = 0) ->
    if (position == 0 || position == 2) and @get('player2').empty()
      @set 'player2', player
      true
    else if (position == 0 || position == 1) and @get('player1').empty()
      @set 'player1', player
      true
    else
      false
  
  ready: ->
    player1 = @get('player1')
    player2 = @get('player2')
    not(player1.empty() or player2.empty())
    
  empty: ->
    return (@get('player1').empty() && @get('player2').empty())
  
  winnerMatch: ->
    @collection.tournament.winnerMatch(@index())
    
  loserMatch: ->
    @collection.tournament.loserMatch(@index())
    
  previousMatch: (player) ->
    number = 'first'
    number = 'second' if player == 2
    @collection.tournament.previousMatch(@index(), number)
    
  index: ->
    try
      return @collection.indexOf(this)+1
    catch error
      return -1
      
Kipscore.Models.Match.setup()
