class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id]) 
  end

  def show
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @new_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    
    if @new_discount.save
      flash.notice = "New Discount Created"
      redirect_to merchant_bulk_discounts_path("#{@merchant.id}")
    else
      flash.notice = "Incomplete Entry - Please Try Again"
      render :new
    end
  end

  private
  def bulk_discount_params
    params.permit(:discount_name, :percentage, :quantity_threshold)
    # params.reqiure(:bulkdiscount).permit(:name, :percentage, :quantity_threshold)
  end

end