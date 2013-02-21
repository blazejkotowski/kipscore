if Rails.env.production? || Rails.env.development? || Rails.env.staging?
  uri = URI.parse(Settings.redis_url)
  $redis = Redis.new :host => uri.host, :port => uri.port, :password => uri.password
end
