class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:info] = I18n.t("custom_translations.signup blocked", :default => "We are sorry, but signing up is blocked in beta version").capitalize
    redirect_to root_path
  end

  def create
    flash[:info] = I18n.t("custom_translations.signup blocked", :default => "We are sorry, but signing up is blocked in beta version").capitalize
    redirect_to root_path
  end
end
