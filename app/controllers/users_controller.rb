class UsersController < ApplicationController
  before_filter :signed_in_user, :only => [:update, :edit, :tournaments]
  before_filter :not_signed_in_user, :only => [:new]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = I18n.t("custom_translations.successfully signed up", :default => "succesfully signed up").capitalize + "!"
      sign_in @user
      redirect_to @user
    else
      render "static_pages/home"
    end
  end

  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
  end
  
  def tournaments
    @tournaments = current_user.tournaments
  end
  
  private
    def not_signed_in_user
      redirect_to user_path if signed_in?
    end

end
