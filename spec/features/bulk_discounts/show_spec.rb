require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show' do
  before(:each) do
    @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones")
    @dk = Merchant.create!(name: "Dickinson-Klein")
    
    @five_for_5 = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"Five for Five")
    @seven_for_7 = BulkDiscount.create!(discount_name:"7 for 7", percentage: 7, quantity_threshold: 7, merchant: @dk)
    @ten_for_10 = BulkDiscount.create!(discount_name:"Lucky 10s", percentage: 10, quantity_threshold: 10, merchant: @dk)

    @double_five = @klein_rempel.bulk_discounts.create!(discount_name:"All 5", percentage: 5, quantity_threshold: 3)
    @threes = @klein_rempel.bulk_discounts.create!(discount_name:"Threes", percentage: 3, quantity_threshold: 3)
  end

  describe "Story 4-the bulk discount show page" do    
    it "displays the bulk discount's attributes (name, percentage discount, and quantity thresholds" do
    
      visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}")

      expect(page).to_not have_content(@double_five.discount_name)
      expect(page).to_not have_content(@seven_for_7.discount_name)
      expect(page).to_not have_content(@ten_for_10.discount_name)
    
      expect(page).to have_content("Quantity Threshold:")
      expect(page).to have_content("Percentage:")
      expect(page).to have_content("#{@five_for_5.discount_name}")      
      expect(page).to have_content("#{@five_for_5.percentage}")
      expect(page).to have_content("#{@five_for_5.quantity_threshold}")
    end

    it 'has an edit link and a seperate delete links' do
      visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}")

      expect(page).to have_content('Delete This Discount')
      expect(page).to have_content('Edit This Discount')
    end
    
    it "deletes the discount if the delete is clicked and returns to the index page, where the discount is no longer displayed" do
      visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}")
    
      click_link ('Delete This Discount')

      expect(current_path).to_not eq("/merchants/#{@dk.id}/edit")
      expect(current_path).to eq("/merchants/#{@dk.id}/bulk_discounts")
    end

    it 'sends user to an edit page if the Edit link is selected' do 
      visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}")
      
      click_link ('Edit This Discount')

      expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts")
      expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/new")
      expect(current_path).to eq("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}/edit")
    end
  end
end