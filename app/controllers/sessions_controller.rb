class SessionsController < ApplicationController
  before_action :logged_in_redirect
  skip_before_action :logged_in_redirect, only: [:destroy]

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])

    login(@user)
  end

  def destroy
    current_user.reset_session_token!
    self.session[:session_token] = nil
    redirect_to new_session_url
  end

  def logged_in_redirect
    redirect_to cats_url unless current_user.nil?
  end

end
