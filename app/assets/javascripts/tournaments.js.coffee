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
    unless tid is undefined
      $("tr.selected").removeClass "selected"
      $("tr[data-tid=\"#{tid}\"]").addClass "selected"
      url = $(".manage-button[data-tid=\"#{tid}\"]").attr "href"
      $tournamentManagementDiv.load url, ->
        $(".datepicker").datepicker { format: "yyyy-mm-dd hh:mm:ss" }
    else
      $('.manage-button').first().trigger "click" 
  
  changeTournament()
  
  
