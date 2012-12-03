class UsersController < ApplicationController
  before_filter :correct_user, :only => [:update, :edit]
  before_filter :signed_in_user, :onlt => [:update, :edit]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Succesfully signed up!"
      sign_in @user
      redirect_to @user
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
  end
  
  def update
  end
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user? @user
    end
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_url, :notice => 'Please sign in'
      end
    end
end
