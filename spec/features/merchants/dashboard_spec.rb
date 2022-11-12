require 'rails_helper'

RSpec.describe 'the Merchant dashboard' do 

  before(:each) do 
    @lisa_frank = Merchant.create!(name: 'Lisa Frank Knockoffs')
    @klein_rempel = Merchant.create!(name: "Klein, Rempel and Jones")
    @dk = Merchant.create!(name: "Dickinson-Klein")
    
    @five_for_5 = @dk.bulk_discounts.create!(percentage: 5, quantity_threshold: 5, discount_name:"Five for Five")
    @seven_for_7 = BulkDiscount.create!(discount_name:"7 for 7", percentage: 7, quantity_threshold: 7, merchant: @dk)
    @ten_for_10 = BulkDiscount.create!(discount_name:"Lucky 10s", percentage: 10, quantity_threshold: 10, merchant: @dk)

    @buy_5_get_5 = BulkDiscount.create!(discount_name:"All 5", percentage: 5, quantity_threshold: 3, merchant: @klein_rempel)
    @buy_5_get_8 = BulkDiscount.create!(discount_name:"5-8", percentage: 8, quantity_threshold: 5, merchant: @klein_rempel)

    @item1 = @lisa_frank.items.create!(name: 'Trapper Keeper', description: 'Its a Lisa Frank Trapper Keeper', unit_price: 3000)
    @item2 = @lisa_frank.items.create!(name: 'Fuzzy Pencil', description: 'Its a fuzzy pencil', unit_price: 500)
    @item3 = @lisa_frank.items.create!(name: 'Leopard Folder', description: 'Its a fuzzy pencil', unit_price: 500)

    @customer1 = Customer.create!(first_name: 'Dandy', last_name: 'Dan')
    @customer2 = Customer.create!(first_name: 'Rockin', last_name: 'Rick')
    @customer3 = Customer.create!(first_name: 'Swingin', last_name: 'Susie')
    @customer4 = Customer.create!(first_name: 'Party', last_name: 'Pete')
    @customer5 = Customer.create!(first_name: 'Swell', last_name: 'Sally')
    @customer6 = Customer.create!(first_name: 'Margarita', last_name: 'Mary')

    @invoice1 = @customer1.invoices.create!(status: 2)
    @invoice2 = @customer2.invoices.create!(status: 1)
    @invoice3 = @customer3.invoices.create!(status: 1, created_at: DateTime.new(1991,3,13,4,5,6))
    @invoice4 = @customer4.invoices.create!(status: 1, created_at: DateTime.new(2001,3,13,4,5,6))
    @invoice5 = @customer5.invoices.create!(status: 2)

    @item1.invoices << @invoice1 << @invoice3 << @invoice4
    @item2.invoices << @invoice2 
    @item3.invoices << @invoice5

    @invoice1.transactions.create!(result: 0)
    @invoice1.transactions.create!(result: 0)
    @invoice1.transactions.create!(result: 0)

    @invoice2.transactions.create!(result: 0)
    @invoice2.transactions.create!(result: 0)

    @invoice3.transactions.create!(result: 0)
    @invoice3.transactions.create!(result: 0)
    @invoice3.transactions.create!(result: 0)
    @invoice3.transactions.create!(result: 0)

    @invoice4.transactions.create!(result: 0)

    @invoice5.transactions.create!(result: 0)

    visit "/merchants/#{@lisa_frank.id}/dashboard"
  end

  # When I visit my merchant dashboard I see the name of my merchant
  it 'shows the name of the merchant' do
    expect(page).to have_content(@lisa_frank.name)
  end

  describe 'links' do 
    it 'to the merchant items index and invoices index' do 
      click_link 'My Items'
      expect(current_path).to eq("/merchants/#{@lisa_frank.id}/items")
    end
    it "has a link to the merchant bulk discounts index page" do
      click_link 'View All My Discounts'
      expect(current_path).to eq(merchant_bulk_discounts_path("#{@lisa_frank.id}"))
    end

    # -- UNCOMMENT AFTER MERCHANT INVOICES INDEX CREATION --
    # it 'to the merchant invoices index' do 
    #   click_link 'My Invoices'

    #   expect(current_path).to eq("/merchants/#{@lisa_frank.id}/invoices")
    # end
  end

  describe 'top 5 customers' do 
    it 'shows top 5 customers' do 
      within '#top_customers' do 
        expect(page).to have_content('Favorite Customers')
        # require 'pry'; binding.pry
        expect(@customer3.name).to appear_before(@customer1.name)
        expect(@customer1.name).to appear_before(@customer2.name)
        expect(@customer2.name).to appear_before(@customer4.name)
        expect(@customer4.name).to appear_before(@customer5.name)
        expect(page).to_not have_content(@customer6.name)
      end
    end

    it 'shows number of transactions next to each customer' do 
      within '#top_customers' do 
        expect(page).to have_content("#{@customer1.name} - 3 purchases")
        expect(page).to have_content("#{@customer2.name} - 2 purchases")
      end
    end
  end

  describe 'items ready to ship' do 
    it 'has a section for items ready to ship' do
      expect(page).to have_content('Items Ready to Ship')
    end

    it 'lists items of imcomplete invoices' do 
      within '#items_ready_to_ship' do 
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item2.name)
        expect(page).to_not have_content(@item3.name)
      end
    end

    it 'shows id of the invoice that hasnt been shipped that links to the invoice show page' do 
      within '#items_ready_to_ship' do 
        expect(page).to have_content("#{@item1.name} - Invoice # #{@invoice3.id}")
        expect(page).to have_content("#{@item1.name} - Invoice # #{@invoice4.id}")
        expect(page).to have_content("#{@item2.name} - Invoice # #{@invoice2.id}")
        
        within "#invoice-#{@invoice3.id}" do 
          click_link "#{@invoice3.id}"

          expect(current_path).to eq("/merchants/#{@lisa_frank.id}/invoices/#{@invoice3.id}")
        end
      end
    end

    it 'shows the date the invoice was created' do 
      within "#invoice-#{@invoice3.id}" do 
        expect(page).to have_content("Wednesday, March 13, 1991")
      end
    end

    it 'orders invoices by least recent' do
      within '#items_ready_to_ship' do
        expect(@invoice3.id.to_s).to appear_before(@invoice4.id.to_s)
        expect(@invoice4.id.to_s).to appear_before(@invoice2.id.to_s)
      end
    end
  end

  describe "Bulk Discount Link" do
    it "has a link to the merchant bulk discounts index page" do
      # save_and_open_page
      click_link 'View All My Discounts'

      expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts")
      expect(current_path).to_not eq("/merchants/#{@dk.id}/bulk_discounts/#{@buy_5_get_5.id}")
      expect(current_path).to_not eq("/merchants/#{@lisa_frank.id}/invoices")

      expect(current_path).to eq("/merchants/#{@lisa_frank.id}/bulk_discounts")
    end
  end
end