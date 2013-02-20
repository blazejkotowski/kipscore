if Rails.env.production? || Rails.env.development?
  uri = URI.parse(ENV["OPENREDIS_URL"])
  $redis = Redis.new :host => uri.host, :port => uri.port, :password => uri.password
end
