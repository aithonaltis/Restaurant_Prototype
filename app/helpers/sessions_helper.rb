module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt] 
    current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  #current_user setter
  def current_user=(user) 
    @current_user = user
  end
  
  #current_user getter
  def current_user
    # OR EQUALS (Lazy creatation, if current_user is undefined)
    @current_user ||= user_from_remember_token
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
    flash[:success] = "Log off was successful"

  end
  
  private
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end
    
    def clear_return_to
      session[:return_to] = nil
    end
end
