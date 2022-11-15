require 'rails_helper'

RSpec.describe "Create New Discount Page" do
  before(:each) do
    @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones")
    @dk = Merchant.create!(name: "Dickinson-Klein")
    
    @five_for_5 = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"Five for Five")
    @seven_for_7 = BulkDiscount.create!(discount_name:"7 for 7", percentage: 7, quantity_threshold: 7, merchant: @dk)
    @ten_for_10 = BulkDiscount.create!(discount_name:"Lucky 10s", percentage: 10, quantity_threshold: 10, merchant: @dk)

    @double_five = @klein_rempel.bulk_discounts.create!(discount_name:"All 5", percentage: 5, quantity_threshold: 3)
    @threes = @klein_rempel.bulk_discounts.create!(discount_name:"Threes", percentage: 3, quantity_threshold: 3)
  end

  describe 'story-2: Merchant can create new bulk discount' do
    it 'does not have any attribute values displaying upon landing on page' do
      visit ("/merchants/#{@klein_rempel.id}/bulk_discounts/new")      
      within('#new-discount-input') do 
        expect(page).to_not have_field(:discount_name, :with => "Double Trouble") 
        expect(page).to_not have_field(:percentage, :with => "2") 
        expect(page).to_not have_field(:quantity_threshold, :with => "2") 
# save_and_open_page ## was not passing test after updating my form
        expect(page).to_not have_field(:discount_name, :with => "#{@five_for_5.discount_name}") 
        expect(page).to_not have_field(:percentage, :with => "#{@threes.percentage}") 
        expect(page).to_not have_field(:quantity_threshold, :with => "#{@double_five.quantity_threshold}") 
# save_and_open_
      end
    end

    describe 'requires complete and valid data input' do 
      it 'retuns user to form page and displays an flash notice' do
        visit ("/merchants/#{@klein_rempel.id}/bulk_discounts/new")
      
        fill_in :discount_name, with: "Double Trouble"
        fill_in :percentage, with: "b"
        fill_in :quantity_threshold, with: "2"
        click_button "Submit"
    
        expect(current_path).to_not eq("/merchants/#{@klein_rempel.id}/bulk_discounts/new")
        expect(current_path).to eq("/merchants/#{@klein_rempel.id}/bulk_discounts")
        expect(page).to have_content("Incomplete Entry - Please Try Again")
      
        fill_in :discount_name, with: "Double Trouble"
        fill_in :percentage, with: "2"
        fill_in :quantity_threshold, with: "2"

        click_button "Submit"
      end
    end
    
    describe "when merchant clicks 'Submit" do
      it 'redirects to the merchant bulk discount index page, where new discount is displayed' do
        visit ("/merchants/#{@klein_rempel.id}/bulk_discounts")
        expect(page).to_not have_content("Double Trouble")
       
        visit ("/merchants/#{@klein_rempel.id}/bulk_discounts/new")
      
        fill_in :discount_name, with: "Double Trouble"
        fill_in :percentage, with: 2
        fill_in :quantity_threshold, with: 2

        click_button "Submit"

        expect(current_path).to_not eq("/merchants/#{@klein_rempel.id}/items")
        expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts")

        expect(current_path).to eq("/merchants/#{@klein_rempel.id}/bulk_discounts")
        expect(page).to have_content("Double Trouble")
        # save_and_open_page 
      end
    end
  end
end