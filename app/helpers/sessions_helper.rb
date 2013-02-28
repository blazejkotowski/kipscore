module SessionsHelper
  
  def return_back_or(default)
    return_url = session[:return_to]
    session.delete(:return_to)
    redirect_to return_url || default   
  end
  
  def store_location
    session[:return_to] = request.url
  end
  
end
