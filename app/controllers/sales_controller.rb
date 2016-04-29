require 'date'

class SalesController < ApplicationController

  def show
    @sale = Sale.where(vendor_id: params[:id]).order(purchase_time: :asc)
    @group = Sale.group("strftime('%m', purchase_time)").count
    render :show
  end

  def month_sale
    @group = Sale.group("strftime('%m', purchase_time)").count
    @v_id = params[:id]
    @month = params[:name]
  end

  def new
    @sale = Sale.new
    @product = Product.where(vendor_id: params[:id])
    @vendor = Vendor.find(@product.vendor_id)
    render :new
  end

  def create
#I HATE THIS IT IS THE WORST:
    params[:sale][:amount] = params[:sale][:amount].to_s.gsub(/\./, '')
#END OF HATE
    @sale = Sale.new(new_sale_create_params[:sale])
    if @sale.save
      @sale[:sale_id] = @sale[:id]
      @sale.save
      redirect_to product_path(@sale.vendor_id)
    else
      render :new
    end
  end

  private

  def new_sale_create_params
    params.permit(sale: [:sale_id, :amount, :vendor_id, :product_id])
  end
end
