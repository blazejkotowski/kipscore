class Kipscore.Routers.Tournaments extends Backbone.Router
  routes:
    '': 'index'
    'show/:id': 'show'
  
  index: ->
    alert 'Index page'
  
  show: (id) ->
    alert "id #{id}"
    
    
