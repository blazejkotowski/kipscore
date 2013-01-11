window.Kipscore =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  bracketInitialize: -> 
    router = new Kipscore.Routers.Tournaments()
    Backbone.history.start()

