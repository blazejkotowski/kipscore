class StaticPagesController < ApplicationController
  
  before_filter :footer_bar

  layout lambda { |controller| request.xhr? ? false : "application" }
  
  def home
    @user = User.new
    @footer_bar = true
  end

  def about
  end

  def contact
  end
  
  def send_email
    email_with_name = "#{params[:name]} <#{params[:email]}>"
    UserMailer.contact_form(params[:subject], params[:message], signed_in? ? current_user : email_with_name).deliver
    flash.now[:info] = "Successfully sent an e-mail."
    render "contact"
  end
  
  def instruction
  end
  
  def innovation
  end
  
  private
    def footer_bar
      @footer_bar = true
    end
end
