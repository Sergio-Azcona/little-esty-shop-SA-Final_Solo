require 'rails_helper'

RSpec.describe 'Edit Bulk Discount Page ' do
  before(:each) do
    @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones")
    @dk = Merchant.create!(name: "Dickinson-Klein")
    
    @five_for_5 = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"Five for Five")
    @seven_for_7 = BulkDiscount.create!(discount_name:"7 for 7", percentage: 7, quantity_threshold: 7, merchant: @dk)
    @ten_for_10 = BulkDiscount.create!(discount_name:"Lucky 10s", percentage: 10, quantity_threshold: 10, merchant: @dk)

    @double_five = @klein_rempel.bulk_discounts.create!(discount_name:"All 5", percentage: 5, quantity_threshold: 3)
    @threes = @klein_rempel.bulk_discounts.create!(discount_name:"Threes", percentage: 3, quantity_threshold: 3)
  end

    describe "Story 5- Show Page - Edit Link sends user to a new page with a form to edit the discount" do
      it "has the discount's current attributes pre-poluated in the form "do 
        visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}/edit")
        within('#edit-discount') do 
          expect(page).to_not have_field(:discount_name, :with => "#{@ten_for_10.quantity_threshold}") 
          expect(page).to_not have_field(:percentage, :with => "#{@threes.percentage}")
          expect(page).to_not have_field(:quantity_threshold, :with => "#{@seven_for_7.quantity_threshold}") 

          expect(page).to have_field(:discount_name, :with => "#{@five_for_5.discount_name}") 
          expect(page).to have_field(:percentage, :with => "#{@five_for_5.percentage}") 
          expect(page).to have_field(:quantity_threshold, :with => "#{@five_for_5.quantity_threshold}") 
      end
        
        # save_and_open_page
      end
    end 


end
