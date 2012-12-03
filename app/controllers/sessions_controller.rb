class SessionsController < ApplicationController

  def new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      sign_in @user
      flash[:success] = 'Successfully signed in'
      return_back_or @user
    else
      flash[:error] = 'There is no such user / password combination'
      redirect_to root_url
    end
  end

  def destroy
    sign_out
    flash[:info] = 'Successfully signed out'
    redirect_to root_url 
  end
  
end
