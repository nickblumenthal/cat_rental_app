class UsersController < ApplicationController
  before_action :logged_in_redirect

  def new

  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
    else
      render :new
    end

  end

  def logged_in_redirect
    redirect_to cats_url unless current_user.nil?
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :password)
    end

end
