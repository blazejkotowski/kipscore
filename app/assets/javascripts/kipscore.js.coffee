window.Kipscore =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  bracketInitialize: -> 
    router = new Kipscore.Routers.Bracket()
    Backbone.history.start()
  playersInitialize: (random = false) ->
    hashParams = jQuery.deparam.fragment()
    tid = hashParams["tid"]
    url = "/tournaments/#{tid}/bracket"
    url += "?random=true" if random
    window.tournament = new Kipscore.Models.Tournament()
    tournament.url = url
    tournament.fetch
      complete: ->
        players_view = new Kipscore.Views.Players({ model: tournament.get('players'), draggable: true })
        window.players_view = players_view
        $("#bracket-modal .modal-body").html('')
        $("#bracket-modal .modal-body").append(players_view.render().el)
  insertNotification: (message, type = "info", selector = ".container.notifications") ->
    $notification = $("<div/>")
                    .addClass("alert alert-#{type}")
                    .html(message)
                    
    $closeButton = $("<button/>")
                  .addClass("close")
                  .attr("type", "button")
                  .attr("data-dismiss", "alert")
                  .html("&times;")
                  .prependTo($notification)
    $(selector).append($notification)
  enableTooltips: =>
    $('.tooltip-trigger').tooltip()

jQuery ->
  
  $(window).on "resize", ->
    fixBackground()
  
  if $("#home-teaser").length > 0
    $("a.about-us, a.innovation, a.instruction").on "click", (event) ->
      event.preventDefault()
      $("#footer-bar a.active").removeClass("active")
      $(event.target).addClass("active")
      $("#home-teaser").slideUp 1000, "easeOutExpo", -> 
        $("#home-teaser").load $(event.target).attr("href"), null, ->
          $("#home-teaser").removeClass("hero-unit").slideDown(1000, "easeOutExpo")
  
  $("#home-teaser a.about-us").on "click", ->
    $("a.about-us").each (index, obj) ->  $(obj).addClass("active")      
  
  $('.datepicker').datepicker({format: 'yyyy-mm-dd', autoclose: true})
  
  $('.tooltip-trigger').tooltip()
