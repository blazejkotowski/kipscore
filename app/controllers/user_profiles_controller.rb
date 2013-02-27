class UserProfilesController < ApplicationController
  before_filter :load_profile
  authorize_resource :user_profile
  
  def update
    unless @user_profile.update_attributes(params[:user_profile])
      flash[:error] = "Avatar size " + @user_profile.errors[:avatar_file_size].first
      flash[:error] ||= "Avatar content type " + @user_profile.errors[:avatar_content_type].first
    end
    redirect_to edit_user_registration_path
  end
  
  private
    def load_profile
      @user_profile = current_user.profile
    end
end
