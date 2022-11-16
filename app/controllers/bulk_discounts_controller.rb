class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id]) 
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @new_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @new_discount = @merchant.bulk_discounts.create(bulk_discount_params)
    # require 'pry';binding.pry
    if @new_discount.save
      flash.notice = "New Discount Created"
      redirect_to merchant_bulk_discounts_path("#{@merchant.id}")
    else
      flash.notice = "Incomplete Entry - Please Try Again"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.find(params[:id])
    
  end

  def update 
    @merchant = Merchant.find(params[:merchant_id])
    @edited_discount = @merchant.bulk_discounts.find(params[:id])
    
    @edited_discount.update(bulk_discount_params)

    if @edited_discount.save
      flash.notice = "Edit(s) Successful"
      redirect_to merchant_bulk_discount_path(@merchant, @edited_discount)    
   else
    flash.notice = "Edit Not Complete - Unacceptable Input - Try Editing Again If Desired"
    redirect_to "/merchants/#{@merchant.id}/bulk_discounts/#{@edited_discount.id}"
   end
  end

  def destroy
    # require 'pry';binding.pry
    @merchant = Merchant.find(params[:merchant_id])
    @delete_discount = @merchant.bulk_discounts.find(params[:id])
    @delete_discount.destroy

    flash.notice = "Discount Deleted"
    redirect_to merchant_bulk_discounts_path("#{@merchant.id}")
  end

  private
  def bulk_discount_params
    params.permit(:discount_name, :percentage, :quantity_threshold)
    # params.reqiure(:bulkdiscount).permit(:name, :percentage, :quantity_threshold)
  end
end