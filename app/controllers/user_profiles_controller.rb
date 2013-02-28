class UserProfilesController < ApplicationController
  before_filter :authenticate_user!, :load_profile, :only => [:update, :edit]
  authorize_resource :user_profile
  
  def edit
    
  end
  
  def update
    @user_profile.assign_attributes(params[:user_profile])
    if @user_profile.valid?
      @user_profile.save
    end
    render 'edit'
  end
  
  def show
    @profile = UserProfile.find_by_link(params[:id])
    raise ActiveRecord::RecordNotFound if @profile.nil?
    @tournaments = @profile.user.tournaments
  end
  
  private
    def load_profile
      @user_profile = current_user.try(:profile)
    end
end
