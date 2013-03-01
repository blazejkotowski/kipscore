jQuery ->
  $('.manage-button').on "click", (event) ->
    event.preventDefault()
    tid = $(event.target).attr "data-tid" 
    window.location.hash = "#tid=#{tid}"    
  
  $(window).on "hashchange", (event) ->
    changeTournament()
    
  $("body").on "change", "#tournament_open", -> 
    if $(event.target).is(":checked")
      $(".tournament-form").show(100)
    else
      $(".tournament-form").hide(100)
  
  $("body").on "click", ".popover-btn", ->
    event.preventDefault()
    if $(event.target).data("shown") == false
      $(event.target).popover("show")
      $(event.target).data("shown", true)
    else
      $(event.target).popover("hide")
      $(event.target).data("shown", false)
      
    
  changeTournament= ->
    hashParams = jQuery.deparam.fragment()
    tid = hashParams["tid"]
    $tournamentManagementDiv = $("#tournament-management")
    $tournamentManagementDiv.html ''
    $loaderDiv = $("#loader")
    $loaderDiv.show()
    unless tid is undefined
      $("tr.info").removeClass "info"
      $("tr[data-tid=\"#{tid}\"]").addClass "info"
      url = $(".manage-button[data-tid=\"#{tid}\"]").attr "href"
      $tournamentManagementDiv.load url, ->
        $loaderDiv.hide();
    else
      $(".manage-button").first().trigger "click" 
  
  enableInputs= ->
    $("#player_name").removeAttr('disabled')
    $("#player_rank").removeAttr('disabled')
  
  disableInputs= ->
    $("#player_name").attr('disabled', 'true')
    $("#player_rank").attr('disabled', 'true')
  
  changeTournament()
  
  $("body").on "click", "#bracket-modal .randomize", (event) ->
    event.preventDefault()
    window.Kipscore.playersInitialize(true) # random bracket
    
  $("body").on "click", "#bracket-modal .save", (event) ->
    event.preventDefault()
    window.tournament.savePlayers -> 
      alert ("saved!")
  
  $("body").on "ajax:success", "form#add-player", (event, data) ->
    if data.created
      player = data.player
      $row = $("<tr/>").attr("data-id", data.player_association.id)
      $row.append($("<td/>").text(player.name))
      if player.rank isnt null
        $row.append($("<td/>").text(player.rank))
      else
        $row.append($("<td/>").text(''))
      
      $delete_button = $("<a/>").attr("href", data.delete_url).addClass("btn btn-danger btn-medium delete-player").text("-")
      $delete_button.attr("data-method", "delete").attr("data-remote", "true").attr("rel", "nofollow")
      $row.append($("<td/>").html($delete_button))
      
      $("#players-table tbody").prepend($row)
      $('#players-table input[type=text]').each (i, t) ->
        $(t).val ''
  
  $("body").on "ajax:success", "a.delete-player", (event, data) ->
    if data.removed
      $("#players-table tr[data-id=#{data.player_association.id}]").remove()
      
  $("body").on "ajax:success", "a.confirm-player", (event, data) ->
    if data.confirmed
      $line = $("#players-table tr[data-id=#{data.player_association.id}]")
      $line.removeClass("unconfirmed")
      $line.find("a.confirm-player").remove()
      
  $("body").on "ajax:beforeSend", "form#add-player", (e, xhr, set) ->
    disableInputs()

  $("body").on "ajax:success", "form#add-player", ->  
    enableInputs()
  
  $("body").on "ajax:success", "#join-modal form", (e, xhr, status) ->
    if xhr.created
      $("#join-modal .modal-body").html('')
      Kipscore.insertNotification(xhr.message, "success", "#join-modal .modal-body")
    else
      $("#join-modal .notifications").html('')
      Kipscore.insertNotification(xhr.message, "error", "#join-modal .notifications")      
    
  $("body").on "click", "#join-modal .join-button", (e) ->
    e.preventDefault()
    $("#join-modal form").submit()

      
  
    
      
