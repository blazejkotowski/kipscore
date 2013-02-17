class ApplicationController < ActionController::Base
  
  # Always come back after login
  before_filter do
    store_location unless self.class == SessionsController
  end
  
  if Rails.env.production?
    http_basic_authenticate_with :name => 'tournaments', :password => 'tournaments'
  end
  
  protect_from_forgery
  
  include SessionsHelper
  include LayoutHelper
  
end
