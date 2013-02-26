class SessionsController < ApplicationController

  def new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      sign_in @user
      flash[:success] = I18n.t("custom_translations.successfully signed in", :default => 'successfully signed in').capitalize
      return_back_or @user
    else
      flash[:error] = I18n.t("custom_translations.wrong user password", :default => 'there is no such user / password combination').capitalize
      redirect_to root_url
    end
  end

  def destroy
    sign_out
    flash[:info] = I18n.t("custom_translations.successfully signed out", :default => 'successfully signed out').capitalize
    redirect_to root_url 
  end
  
end
