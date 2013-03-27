class Kipscore.Models.BracketMatch extends Kipscore.Models.Match

  tournament: ->
    @collection.tournament  
      
  setNextMatches: ->
    if @get 'finished'
      return false
    
    wmatch = @winnerMatch()
    lmatch = @loserMatch()
        
    unless wmatch is false
      wmatch.addPlayer @get('winner'), @index()%2 ? 1 : 2
    else
      position = @collection.tournament.get('min_position')
      unless @get('winner').bye()
        @get('winner').set('end_position', position)
        @collection.tournament.mainTournament().get('results').add(position, @get('winner'))
    unless lmatch is false
      lmatch.addPlayer @get('loser'), @index()%2 ? 1 : 2
    else
      position = @collection.tournament.get('min_position')+1
      unless @get('loser').bye()
        @get('loser').set('end_position', position)
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
    
  winnerMatch: ->
    @collection.tournament.winnerMatch(@index())
    
  loserMatch: ->
    @collection.tournament.loserMatch(@index())
    
  previousMatch: (player) ->
    number = 'first'
    number = 'second' if player == 2
    @collection.tournament.previousMatch(@index(), number)
    
  undoPlayer: (number=1) ->
    player_attr = "player#{number}"
    prev_match = @previousMatch(number)    
    prev_match.undoMatch()
    
    # reset player
    @set player_attr, new Kipscore.Models.Player()
    # reset state and scores
    @set 'finished', false
    @set 'scores', new Array()
    
    @trigger "to_save"
    
  undoMatch: ->
    @restart()
    
    loser_match = @loserMatch()
    winner_match = @winnerMatch()
    
    loser_match.restart()
    winner_match.restart()
    
    if @index()%2
      loser_match.set('player1', new Kipscore.Models.Player())
      winner_match.set('player1', new Kipscore.Models.Player())
    else
      loser_match.set('player2', new Kipscore.Models.Player())
      winner_match.set('player2', new Kipscore.Models.Player())
    
    @set('finished', false)
    
  columnNumber: ->
    @collection.tournament.columnNumber(@index())
    
  index: ->
    try
      return @collection.indexOf(this)+1
    catch error
      return -1
      
Kipscore.Models.BracketMatch.setup()
