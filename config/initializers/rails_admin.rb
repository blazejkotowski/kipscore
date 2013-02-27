RailsAdmin.config do |config|
  config.main_app_name = ["Kipscore"]
  config.current_user_method { current_user } 
  config.authorize_with :cancan
end
