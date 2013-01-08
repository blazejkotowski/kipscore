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
        $(".datepicker").datepicker { format: "yyyy-mm-dd hh:mm:ss" }
    else
      $(".manage-button").first().trigger "click" 
  
  changeTournament()
  
  
