class UsersController < ApplicationController
  before_filter :signed_in_user, :only => [:update, :edit]
  before_filter :correct_user, :only => [:update, :edit]
  
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
      render "static_pages/home"
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
        flash[:notice] = 'Please sign in'
        redirect_to root_url
      end
    end
end
