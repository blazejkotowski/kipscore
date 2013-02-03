jQuery ->
  $('.manage-button').on "click", (event) ->
    event.preventDefault()
    tid = $(event.target).attr "data-tid" 
    window.location.hash = "#tid=#{tid}"    
  
  $(window).on "hashchange", (event) ->
    changeTournament()
    
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
  
  changeTournament()
  
  $("body").on "ajax:success", "form#add-player", (event, data) ->
    if data.created
      player = data.player
      $row = $("<tr/>").attr("data-id", player.id)
      $row.append($("<td/>").text(player.name))
      $row.append($("<td/>").text(player.rank))
      
      $delete_button = $("<a/>").attr("href", data.delete_url).addClass("btn btn-danger btn-medium delete-player").text("-")
      $delete_button.attr("data-method", "delete").attr("data-remote", "true").attr("rel", "nofollow")
      $row.append($("<td/>").html($delete_button))
      
      $("#players-table tbody").prepend($row)
      $('#players-table input[type=text]').each (i, t) ->
        $(t).val ''
    else
      alert "Not created"
  
  
  $("body").on "ajax:success", "a.delete-player",  (event, data) ->
    if data.removed
      $("#players-table tr[data-id=#{data.player.id}]").remove()
    else
      alert "Not removed"
    
