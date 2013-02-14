window.Kipscore =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  bracketInitialize: -> 
    router = new Kipscore.Routers.Tournaments()
    Backbone.history.start()

bar_hidden = true
bar_class_set = false

showBar = ->
  if bar_hidden
    bar_hidden = false
    
    $bar = $("#footer-bar")
    $bar.delay(200).slideDown(200)
    
    contentHeight = $("#main-container").offset().top + $("#main-container").outerHeight()
    if contentHeight + 122 > $(window).height()
      bar_class_set = true
      $('footer').removeClass("without-bar",1).addClass('with-bar', 200)
  
hideBar = ->
  unless bar_hidden
    bar_hidden = true
    $bar = $("#footer-bar")
    $bar.slideUp(200)
    
    if bar_class_set
      bar_class_set = false
      $('footer').addClass('without-bar', 200).removeClass("with-bar",1)
    
toggleBar = ->
  bottomOffset = $(document).height() - $(window).height() - $(window).scrollTop()
  if bottomOffset <= 0
    showBar()
  else if bottomOffset >= 150
    hideBar()

jQuery ->
  setTimeout(toggleBar, 500)
  $(window).on "scroll resize", ->
    toggleBar()
  
  $(window).on "resize", ->
    fixBackground()
    
  if $("#home-teaser").length > 0
    $("a.about-us, a.innovation, a.instruction").on "click", (event) ->
      event.preventDefault()
      $("#home-teaser").slideUp 1000, "easeOutExpo", -> 
        $("#home-teaser").load $(event.target).attr("href"), null, -> 
          $("#home-teaser").removeClass("hero-unit").slideDown(1000, "easeOutExpo")
      
