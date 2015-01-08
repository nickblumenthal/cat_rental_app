class CatRentalRequestsController < ApplicationController
  before_action :verify_owner
  skip_before_action :verify_owner, only: [:new, :create]

  def new
    @all_cats = Cat.all
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(cat_rental_request_params)
    @request.user_id = current_user.id
    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      @all_cats = Cat.all
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat_id)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat_id)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def verify_owner
    request = CatRentalRequest.find(params[:id])
    redirect_to cats_url unless current_user.id == request.owner.id
  end
end
