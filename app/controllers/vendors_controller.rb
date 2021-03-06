class VendorsController < ApplicationController

  def index
    @vendors = Vendor.order(vendor_name: :asc)
    render :index
  end

  def show
    @vendors = Vendor.where(id: params[:id])
    render :single_vendor_view
  end

  def new
    @new_vendor = Vendor.new
    @market = Market.where(id: params[:id]).first
  end

  def create
    @new_vendor = Vendor.new(new_vendor_create_params[:vendor])
    @mark_id = @new_vendor.market_id
    if @new_vendor.save
      @new_vendor[:vendor_id] = @new_vendor[:id]
      @new_vendor.save
      redirect_to market_path(@mark_id)
    else
      render :new
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
    render :edit
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update(new_vendor_create_params[:vendor])
      redirect_to market_path(@vendor.market_id)
    else
      render :edit
    end
  end

  def destroy
    @vendor = Vendor.destroy(params[:id])
    redirect_to root_path
  end

  private

  def new_vendor_create_params
    params.permit(vendor: [:vendor_id, :vendor_name, :num_of_employees, :market_id]) #you must permit parameters when you want to allow access to the user to create new data using the params. The user is ONLY permitted to access the artist and title parameters.
  end
end
