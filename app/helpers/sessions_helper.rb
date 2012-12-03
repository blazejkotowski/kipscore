module SessionsHelper
  
  def sign_in(user)
    cookies.permanent[:authentication_token] = user.authentication_token
    self.current_user = user
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete :authentication_token
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= User.find_by_authentication_token cookies[:authentication_token]
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    current_user == user
  end
  
  def return_back_or(default)
    session.delete(:return_to)
    redirect_to session[:return_to] || default   
  end
  
  def store_location
    session[:return_to] = request.url
  end
  
end
