class ApplicationController < ActionController::Base
  
  before_filter :set_locale, :set_mailer_host, :set_body_class
  
  if Rails.env.staging?
    http_basic_authenticate_with :name => 'tournaments', :password => 'tournaments'
  end
  
  protect_from_forgery
  
  include SessionsHelper
  include LayoutHelper
  
  private
    def set_locale
      parsed_locale = request.host.split('.').last
      parsed_locale = params[:lang] if params[:lang].present? && Rails.env.development?
      I18n.locale = parsed_locale if I18n.available_locales.include? parsed_locale.to_sym
      params[:locale] = I18n.locale
    end
    
    def set_mailer_host
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end
    
    def set_body_class 
      @body_class = ''
      @body_class += "bracket " if params[:action] == "bracket"
      @body_class += "static " if ['static_pages', 'sessions', 'devise'].include? params[:controller].split('/').first
      @body_class += "with-bar" if @footer_bar.present?
      @body_class = nil if @body_class.empty?
    end
  
end
