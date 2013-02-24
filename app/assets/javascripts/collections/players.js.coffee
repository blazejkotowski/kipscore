class Kipscore.Collections.Players extends Backbone.Collection

  model: Kipscore.Models.Player
  url: window.location.pathname + '.json'
