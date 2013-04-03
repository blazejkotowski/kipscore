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
    # uncomment to enable
#    @on "change:player1 change:player2", ->
#      try
#        if @pickWinner()
#          @setNextMatches()
          
    @on "to_save", ->
      try
        @tournament().trigger "to_save"

  tournament: ->
    null 
      
  pickWinner: ->
    # Not picked if match not ready
    unless @ready() && @collection.tournament.mainTournament().get('admin')
      return false
      
    # Match with bye case
    if @get('player1').get('bye') && not @get('player2').empty()
      @get('player2').set("winner", true) 
      @set 'winner', @get('player2')
      @set 'loser', @get('player1')
      return true
    if @get('player2').get('bye') && not @get('player1').empty()
      @get('player1').set("winner", true) 
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
      @get('player1').set("winner", true) 
      @set 'winner', @get('player1')
      @set 'loser', @get('player2')
      true
    # Player2 win
    else if res2 > res1
      @get('player2').set('winner',true)
      @set 'winner', @get('player2')
      @set 'loser', @get('player1')
      true
    # Draw
    else
      false
  
  matchInfo: ->
    t = @get('tournament')
    p1 = @get('player1')
    p2 = @get('player2')
    console.log "Tournament #{t.get('min_position')} - #{t.get('max_position')}"
    console.log "index: #{@index()}"
    console.log "Players:\n\t 1: #{p1.get('name')}\n\t 2: #{p2.get('name')}"
        
  addScores: (p1,p2) ->
    @get('scores').push([parseInt(p1),parseInt(p2)])
    @trigger "to_save"
    this
      
  addPlayer: (player, position = 0) ->
    if (position == 0 || position == 2) and @get('player2').empty()
      @set 'player2', player.clone()
      true
    else if (position == 0 || position == 1) and @get('player1').empty()
      @set 'player1', player.clone()
      true
    else
      false
  
  ready: ->
    player1 = @get('player1')
    player2 = @get('player2')
    not(player1.empty() or player2.empty())
  
  human: ->
    @get('player1').human() && @get('player2').human()
    
  empty: ->
    return ((@get('player1').empty() && @get('player2').empty()) ||
            (@get('player1').empty() && @get('player2').bye()) ||
            (@get('player2').empty() && @get('player1').bye()) ||
            (@get('player1').bye() && @get('player2').bye()))
  
    
  restart: ->
    @get('player1').set('winner', false)
    @get('player2').set('winner', false)
    @set
      'scores': new Array()
      'winner': null
      'loser': null
      'finished': false
    
Kipscore.Models.Match.setup()
