window.Kipscore =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  bracketInitialize: -> 
    router = new Kipscore.Routers.Tournaments()
    Backbone.history.start()

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
