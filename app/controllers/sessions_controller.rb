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
      redirect_to root_url, :error => 'There is no such user / password combination'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, :info => 'Successfully signed out'
  end
  
end
