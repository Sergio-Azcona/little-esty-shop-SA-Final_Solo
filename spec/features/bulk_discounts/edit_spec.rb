require 'rails_helper'

RSpec.describe 'Edit Bulk Discount Page ' do
  before(:each) do
    @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones")
    @dk = Merchant.create!(name: "Dickinson-Klein")
    
    @five_for_5 = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"Five for Five")
    @seven_for_7 = BulkDiscount.create!(discount_name:"7 for 7", percentage: 7, quantity_threshold: 7, merchant: @dk)
    @ten_for_10 = BulkDiscount.create!(discount_name:"Lucky 10s", percentage: 10, quantity_threshold: 10, merchant: @dk)
    @discount_to_edit = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"discount to edit")

    @double_five = @klein_rempel.bulk_discounts.create!(discount_name:"All 5", percentage: 5, quantity_threshold: 3)
    @threes = @klein_rempel.bulk_discounts.create!(discount_name:"Threes", percentage: 3, quantity_threshold: 3)
  end

    describe "Story 5- Show Page - Edit Link sends user to a new page with a form to edit the discount" do
      it "has the discount's current attributes pre-poluated in the form "do 
        visit ("/merchants/#{@dk.id}/bulk_discounts/#{@discount_to_edit.id}/edit")
        within('#edit-discount') do 
          expect(page).to_not have_field(:discount_name, :with => "#{@ten_for_10.discount_name}") 
          expect(page).to_not have_field(:percentage, :with => "#{@threes.percentage}")
          expect(page).to_not have_field(:quantity_threshold, :with => "#{@seven_for_7.quantity_threshold}") 

          expect(page).to have_field(:discount_name, :with => "#{@discount_to_edit.discount_name}") 
          expect(page).to have_field(:percentage, :with => "#{@discount_to_edit.percentage}") 
          expect(page).to have_field(:quantity_threshold, :with => "#{@discount_to_edit.quantity_threshold}") 
        end
      end
        
      it 'with invalid input- returns user to the edit page' do
        visit ("/merchants/#{@dk.id}/bulk_discounts/#{@discount_to_edit.id}/edit")

        fill_in :discount_name, with: "Five-for_Five"
        fill_in :percentage, with: "100"
        fill_in :quantity_threshold, with: "word"
        click_button "Submit"

        
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts")
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/#{@seven_for_7.id}")
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}/edit")
        
        # save_and_open_page
        expect(current_path).to eq("/merchants/#{@dk.id}/bulk_discounts/#{@discount_to_edit.id}")
        expect(page).to have_content("Edit Not Complete - Unacceptable Input - Try Editing Again If Desired")
      end

      it 'with valid input- returns user to the show page once they click submit and displays the changes in the show page' do
        visit ("/merchants/#{@dk.id}/bulk_discounts/#{@discount_to_edit.id}/edit")

        fill_in :discount_name, with: "Discount Is Edited - This is Fresh!"
        fill_in :percentage, with: "5"
        fill_in :quantity_threshold, with: "5"
        click_button "Submit"

        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts")
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/#{@threes.id}")
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/#{@seven_for_7.id}")
        expect(page).to_not have_content("discount to edit")
        # save_and_open_page
        expect(current_path).to eq("/merchants/#{@dk.id}/bulk_discounts/#{@discount_to_edit.id}")
        expect(page).to have_content("Discount Is Edited - This is Fresh!")
        expect(page).to have_content("5")
        expect(page).to have_content("5")
      end
    end 


end
