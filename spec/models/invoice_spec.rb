require 'rails_helper' 

RSpec.describe Invoice do 
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    # it { should have_one(:merchant).through(:items) }
    # it { should have_many(:bulk_discounts).through(:1) }
  end 

  describe "model methods" do
    before(:each) do
      @kevins_shop = Merchant.create!(name: "Kevin's Illegal goods") 
      @dk = Merchant.create!(name: "Denver PC parts") 

      @sean = Customer.create!(first_name: "Sean", last_name: "Culliton") 
      @sergio = Customer.create!(first_name: "Sergio", last_name: "Azcona") 
      @emily = Customer.create!(first_name: "Emily", last_name: "Port") 

      @funnypowder = Item.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 100, merchant: @kevins_shop) 
      @trex = Item.create!(name: "T-Rex", description: "Skull of a Dinosaur", unit_price: 100, merchant: @kevins_shop) 
      @ufo = Item.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 50, merchant: @kevins_shop) 

      @invoice1_sergio_20 = Invoice.create!(status: 1, customer: @sergio, created_at: "2020-11-01 11:00:00 UTC") 
      @invoice2_sean_21 = Invoice.create!(status: 2, customer: @sean, created_at: "2021-11-01 11:00:00 UTC") 
      @invoice3_emily_22 = Invoice.create!(status: 2, customer: @emily, created_at: "2022-11-01 11:00:00 UTC") 
      @invoice4_sergio_20 = Invoice.create!(status: 1, customer: @sergio, created_at: "2002-11-01 11:00:00 UTC") 
      @invoice5_sean_21 = Invoice.create!(status: 2, customer: @sean, created_at: "2003-11-02 11:00:00 UTC") 
      @invoice6_emily_22 = Invoice.create!(status: 0, customer: @emily, created_at: "2004-11-03 11:00:00 UTC") 
      
      @invoice1_funny = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 2, item: @funnypowder, invoice: @invoice1_sergio_20) 
      @invoice1_trex = InvoiceItem.create!(quantity: 10, unit_price: 100, status: 1, item: @trex, invoice: @invoice1_sergio_20)
      # @invoice1_trex = InvoiceItem.create!(quantity: 10, unit_price: 50, status: 1, item: @ufo, invoice: @invoice1_sergio_20) 
      @invoice2_ufo = InvoiceItem.create!(quantity: 4, unit_price: 50, status: 2, item: @ufo, invoice: @invoice2_sean_21) 
      @invoice2_trex = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 1, item: @trex, invoice: @invoice2_sean_21) 

      @two_get_twenty = BulkDiscount.create!(discount_name:"2 get 20!", percentage: 20, quantity_threshold: 2, merchant: @kevins_shop) 
      @threes = BulkDiscount.create!(discount_name:"Threes", percentage: 3, quantity_threshold: 3, merchant: @kevins_shop) 
      @four_fives = BulkDiscount.create!(discount_name:"4Five", percentage: 5, quantity_threshold: 4, merchant: @kevins_shop) 
      @perfect_10 = BulkDiscount.create!(discount_name:"Perfect 10s", percentage: 10, quantity_threshold: 10, merchant: @kevins_shop) 
    end 


    xit "returns invocoices that have items which have not been shipped" do
      # require 'pry';binding.pry 
      expect(Invoice.unshipped_items.count).to include([@invoice1_sergio_20,@invoice2_sean_21])
    end


    xit 'can calculate total revenue of an invoice' do 
      
      expect(@invoice1_sergio_20.total_revenue).to eq(1700) 
      expect(@invoice2_sean_21.total_revenue).to eq(300) 
    end

    xit "has bulk discounts" do
      expect(@invoice1_sergio_20.invoice_discounted_revenue).to eq 300
      # expect(@invoice2_sean_21.invoice_discounted_revenue).to eq 300
      expect(@invoice3_emily_22.invoice_discounted_revenue).to eq 300
    end

    
    xit 'calculates the discount applied' do
      expect(@invoice1_sergio_20.discount_calculation).to eq(55)
    end
  end



  xdescribe "#unshipped_items" do
    before :each do 
      @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones") 
      @dk = Merchant.create!(name: "Dickinson-Klein") 
      
      @watch = @klein_rempel.items.create!(name: "Watch", description: "Tells time on your wrist", unit_price: 300) 
      @radio = @klein_rempel.items.create!(name: "Radio", description: "Broadcasts radio stations", unit_price: 150) 
      @speaker = @klein_rempel.items.create!(name: "Speakers", description: "Listen to your music LOUD", unit_price: 250) 
      
      @ufo = @dk.items.create!(name: "UFO Board", description: "Out of this world MotherBoard", unit_price: 400) 
      @funnypowder = @dk.items.create!(name: "Funny Brick of Powder", description: "White Powder with Gasoline Smell", unit_price: 100) 
      @binocular = @dk.items.create!(name: "Binoculars", description: "See everything from afar", unit_price: 300) 
      @tent = @dk.items.create!(name: "Tent", description: "Spend the night under the stars... or under THEM!", unit_price: 500)    
      
      @sean = Customer.create!(first_name: "Sean", last_name: "Culliton") 
      @sergio = Customer.create!(first_name: "Sergio", last_name: "Azcona") 
      @emily = Customer.create!(first_name: "Emily", last_name: "Port") 
      @kevin = Customer.create!(first_name: "Kevin", last_name: "Ta")  
      @billy = Customer.create!(first_name: "Billy", last_name: "Smith")  
      @john = Customer.create!(first_name: "John", last_name: "Doe")  
  
      @invoice1_sergio_20 = Invoice.create!(status: 1, customer: @sergio, created_at: "2002-11-01 11:00:00 UTC") 
      @invoice2_sean_21 = Invoice.create!(status: 0, customer: @sean, created_at: "2003-11-02 11:00:00 UTC") 
      @invoice3_emily_22 = Invoice.create!(status: 0, customer: @emily, created_at: "2004-11-03 11:00:00 UTC") 
      # @invoice4 = Invoice.create!(status: 1, customer: @kevin, created_at: "2005-11-04 11:00:00 UTC") 
      # @invoice5 = Invoice.create!(status: 2, customer: @emily, created_at: "2006-11-01 11:00:00 UTC") 
      # @invoice6 = Invoice.create!(status: 2, customer: @sean, created_at: "2007-11-02 11:00:00 UTC") 
      # @invoice7 = Invoice.create!(status: 1, customer: @emily, created_at: "2008-11-03 11:00:00 UTC") 
      # @invoice8 = Invoice.create!(status: 2, customer: @kevin, created_at: "2009-11-04 11:00:00 UTC") 
      # @invoice9 = Invoice.create!(status: 0, customer: @sean, created_at: "2010-11-02 11:00:00 UTC") 
      # @invoice1_sergio_200 = Invoice.create!(status: 1, customer: @emily, created_at: "2011-11-03 11:00:00 UTC") 
      @invoice1_sergio_201 = Invoice.create!(status: 2, customer: @sergio, created_at: "2012-11-04 11:00:00 UTC") 
      @invoice1_sergio_202 = Invoice.create!(status: 2, customer: @kevin, created_at: "2013-11-02 11:00:00 UTC") 
      @invoice1_sergio_203 = Invoice.create!(status: 2, customer: @emily, created_at: "2014-11-03 11:00:00 UTC") 
      @invoice1_sergio_204 = Invoice.create!(status: 2, customer: @billy, created_at: "2015-11-04 11:00:00 UTC") 
  
      @transaction1 = invoice1_sergio_20.transactions.create!(result: 0) 
      @transaction2 = invoice2_sean_21.transactions.create!(result: 0) 
      @transaction3 = invoice3_emily_22.transactions.create!(result: 0) 
      @transaction4 = @invoice4.transactions.create!(result: 0) 
      @transaction5 = @invoice5.transactions.create!(result: 0) 
      @transaction6 = @invoice6.transactions.create!(result: 0) 
      @transaction7 = @invoice7.transactions.create!(result: 0) 
      @transaction8 = @invoice8.transactions.create!(result: 0) 
      @transaction9 = @invoice9.transactions.create!(result: 0) 
      @transaction10 = invoice1_sergio_200.transactions.create!(result: 0) 
      @transaction11 = invoice1_sergio_201.transactions.create!(result: 0) 
      @transaction12 = invoice1_sergio_202.transactions.create!(result: 0) 
      @transaction13 = invoice1_sergio_203.transactions.create!(result: 0) 
      @transaction14 = invoice1_sergio_204.transactions.create!(result: 0) 
      
      @invoice1_funny = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 0, item: @ufo, invoice: @invoice1_sergio_20) 
      @invoice2_trex = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice2_sean_21) 
      @i2nufo_item3 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @binocular, invoice: @invoice3_emily_22) 
      @invoice_item4 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 0, item: @funnypowder, invoice: @invoice4) 
      @invoice_item5 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice5) 
      @invoice_item6 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @binocular, invoice: @invoice6) 
      @invoice_item7 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 0, item: @ufo, invoice: @invoice7) 
      @invoice_item8 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice8) 
      @invoice_item9 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @binocular, invoice: @invoice9) 
      @invoice1_funny0 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 0, item: @ufo, invoice: @invoice1_sergio_200) 
      @invoice1_funny1 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice1_sergio_201) 
      @invoice1_funny2 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice1_sergio_202) 
      @invoice1_funny3 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @binocular, invoice: @invoice1_sergio_203) 
      @invoice1_funny4 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @binocular, invoice: @invoice1_sergio_204) 
      @invoice1_funny5 = InvoiceItem.create!(quantity: 1, unit_price: 100, status: 0, item: @binocular, invoice: @invoice1_sergio_20) 
      @invoice1_funny6 = InvoiceItem.create!(quantity: 2, unit_price: 100, status: 1, item: @tent, invoice: @invoice1_sergio_20) 
      @invoice1_funny7 = InvoiceItem.create!(quantity: 54, unit_price: 8000, status: 2, item: @funnypowder, invoice: @invoice2_sean_21) 
      
      # visit ("/admin")
    end

    # it "returns invocoices that have items which have not been shipped" do
      
    #   # require 'pry';binding.pry 
    #   expect(Invoice.unshipped_items.size).to eq([invoice2_sean_21,invoice3_emily_22,@invoice4,@invoice7,@invoice9])
    # end

  #   it "has bulk discounts" do
  #     expect(invoice2_sean_21.total_revenue).to eq 160
  #   end
  end
end