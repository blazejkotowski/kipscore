class Autocomplete
  def initialize(app)
    @app = app
  end
  
  def call(env)
    if env["PATH_INFO"] == "/players/autocomplete"
      request = Rack::Request.new(env)
      terms = Player.autocomplete(request.params["ranking_id"],request.params["term"] || "")
      [200, {"Content-type" => "application/json"}, [terms.to_json]]
    else
      @app.call(env)
    end 
  end
end
