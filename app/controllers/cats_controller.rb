class CatsController < ApplicationController
  before_action :logged_in_redirect
  before_action :verify_owner
  skip_before_action :verify_owner, only: [:index, :new, :show, :create]


  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end

  def logged_in_redirect
    redirect_to new_session_url if current_user.nil?
  end

  def verify_owner
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless @cat.user_id == current_user.id
  end


end
