class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    return nil if self.session[:session_token].nil?
    @user ||= OpenSession.find_by(session_token: session[:session_token]).user
  end

  def login(user)

    fail
    # if user.nil?
    #   render :new
    # else
    #   user.reset_session_token!
    #   self.session[:session_token] = user.open_sessions. ###continue here -search by location
    #   redirect_to cats_url
    # end

  end

end
