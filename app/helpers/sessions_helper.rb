module SessionsHelper
  
  def return_back_or(default)
    return_url = session[:return_to]
    session.delete(:return_to)
    redirect_to return_url || default   
  end
  
  def store_location
    session[:return_to] = request.url
  end
  
  def signed_in_user
    unless user_signed_in?
      store_location
      flash[:notice] = 'Please sign in'
      redirect_to root_url
    end
  end
  
end
