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
  
  $("form#add-player").on "ajax:success", (event, data) ->
    if data["created"]
      player = data["player"]
      $row = $("<tr/>")
      $row.append($("<td/>").text(player["name"]))
      $row.append($("<td/>").text(player["rank"]))
      $row.append($("<td/>"))
      $("#players-table tbody").prepend($row)
      $('#players-table input[type=text]').each (i, t) ->
        $(t).val ''
    else
      alert "Not created"
      
    
