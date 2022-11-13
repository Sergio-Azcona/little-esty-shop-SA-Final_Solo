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

    @watch = @klein_rempel.items.create!(name: "Watch", description: "Tells time on your wrist", unit_price: 300)
    @radio = @klein_rempel.items.create!(name: "Radio", description: "Broadcasts radio stations", unit_price: 150)
    @speaker = @klein_rempel.items.create!(name: "Speakers", description: "Listen to your music LOUD", unit_price: 250)
    
    @ufo = @dk.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400)
    @funnypowder = @dk.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 5000)
    @binocular = @dk.items.create!(name: "Binoculars", description: "See everything from afar", unit_price: 300)
    @tent = @dk.items.create!(name: "Tent", description: "Spend the night under the stars... or under THEM!", unit_price: 500)   
    
    @sean = Customer.create!(first_name: "Sean", last_name: "Culliton")
    @sergio = Customer.create!(first_name: "Sergio", last_name: "Azcona")
    @emily = Customer.create!(first_name: "Emily", last_name: "Port")
    @kevin = Customer.create!(first_name: "Kevin", last_name: "Ta") 
    @billy = Customer.create!(first_name: "Billy", last_name: "Smith") 
    @john = Customer.create!(first_name: "John", last_name: "Doe") 

    @invoice1 = Invoice.create!(status: 1, customer_id: @sergio.id, created_at: "2002-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(status: 0, customer_id: @sean.id, created_at: "2003-11-02 11:00:00 UTC")
    @invoice3 = Invoice.create!(status: 0, customer_id: @emily.id, created_at: "2004-11-03 11:00:00 UTC")
    @invoice4 = Invoice.create!(status: 1, customer_id: @kevin.id, created_at: "2005-11-04 11:00:00 UTC")
    @invoice5 = Invoice.create!(status: 2, customer_id: @emily.id, created_at: "2006-11-01 11:00:00 UTC")
    @invoice6 = Invoice.create!(status: 2, customer_id: @sean.id, created_at: "2007-11-02 11:00:00 UTC")
    @invoice7 = Invoice.create!(status: 1, customer_id: @emily.id, created_at: "2008-11-03 11:00:00 UTC")
    @invoice8 = Invoice.create!(status: 2, customer_id: @kevin.id, created_at: "2009-11-04 11:00:00 UTC")
    @invoice9 = Invoice.create!(status: 0, customer_id: @sean.id, created_at: "2010-11-02 11:00:00 UTC")
    @invoice10 = Invoice.create!(status: 1, customer_id: @emily.id, created_at: "2011-11-03 11:00:00 UTC")
    @invoice11 = Invoice.create!(status: 2, customer_id: @sergio.id, created_at: "2012-11-04 11:00:00 UTC")
    @invoice12 = Invoice.create!(status: 2, customer_id: @kevin.id, created_at: "2013-11-02 11:00:00 UTC")
    @invoice13 = Invoice.create!(status: 2, customer_id: @emily.id, created_at: "2014-11-03 11:00:00 UTC")
    @invoice14 = Invoice.create!(status: 2, customer_id: @billy.id, created_at: "2015-11-04 11:00:00 UTC")

    @transaction1 = @invoice1.transactions.create!(result: 0)
    @transaction2 = @invoice2.transactions.create!(result: 0)
    @transaction3 = @invoice3.transactions.create!(result: 0)
    @transaction4 = @invoice4.transactions.create!(result: 0)
    @transaction5 = @invoice5.transactions.create!(result: 0)
    @transaction6 = @invoice6.transactions.create!(result: 0)
    @transaction7 = @invoice7.transactions.create!(result: 0)
    @transaction8 = @invoice8.transactions.create!(result: 0)
    @transaction9 = @invoice9.transactions.create!(result: 0)
    @transaction10 = @invoice10.transactions.create!(result: 0)
    @transaction11 = @invoice11.transactions.create!(result: 0)
    @transaction12 = @invoice12.transactions.create!(result: 0)
    @transaction13 = @invoice13.transactions.create!(result: 0)
    @transaction14 = @invoice14.transactions.create!(result: 0)
    
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @ufo.id, invoice_id: @invoice1.id)
    @invoice_item2 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice2.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @binocular.id, invoice_id: @invoice3.id)
    @invoice_item4 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @funnypowder.id, invoice_id: @invoice4.id)
    @invoice_item5 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice5.id)
    @invoice_item6 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @binocular.id, invoice_id: @invoice6.id)
    @invoice_item7 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @ufo.id, invoice_id: @invoice7.id)
    @invoice_item8 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice8.id)
    @invoice_item9 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @binocular.id, invoice_id: @invoice9.id)
    @invoice_item10 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @ufo.id, invoice_id: @invoice10.id)
    @invoice_item11 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice11.id)
    @invoice_item12 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice12.id)
    @invoice_item13 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @binocular.id, invoice_id: @invoice13.id)
    @invoice_item14 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @binocular.id, invoice_id: @invoice14.id)
    @invoice_item15 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 0, item_id: @binocular.id, invoice_id: @invoice1.id)
    @invoice_item16 = InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 1, item_id: @tent.id, invoice_id: @invoice1.id)
    @invoice_item17 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item_id: @funnypowder.id, invoice_id: @invoice2.id)
  end

  describe "Story 4-the bulk discount show page" do    
    it "displays the bulk discount's attributes (name, percentage discount, and quantity thresholds" do
    
      visit ("/merchants/#{@dk.id}/bulk_discounts/#{@five_for_5.id}")

      expect(page).to_not have_content(@double_five.discount_name)
 
      expect(page).to_not have_content(@seven_for_7.discount_name)
      expect(page).to_not have_content(@ten_for_10.discount_name)
      
      # within("#discount-list-#{@five_for_5.id}") do
        expect(page).to have_content("#{@five_for_5.discount_name}")      
        expect(page).to have_content("#{@five_for_5.percentage}")
        expect(page).to have_content("#{@five_for_5.quantity_threshold}")
      
      # end
    end
  end
end