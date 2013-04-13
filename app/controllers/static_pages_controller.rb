class StaticPagesController < ApplicationController
  
  before_filter :footer_bar, :except => [:home]
  before_filter :signup_form, :only => [:organizer, :observer, :player]

  layout lambda { |controller| request.xhr? ? false : "application" }
  
  def home
    if user_signed_in?
      redirect_to tournaments_user_path
    end
    @user = User.new
  end

  def about
  end

  def contact
  end
  
  def send_email
    email_with_name = "#{params[:name]} <#{params[:email]}>"
    UserMailer.contact_form(params[:subject], params[:message], user_signed_in? ? current_user : email_with_name).deliver
    flash.now[:info] = I18n.t("custom_translations.successfully sent an email", :default => "successfully sent an email").capitalize
    render "contact"
  end
  
  def instruction
  end
  
  def innovation
  end
  
  def organizer
  end
  
  def player
  end
  
  def observer
  end
  
  private
    def signup_form
      @user = User.new
    end
    def footer_bar
      @footer_bar = true
    end
end
