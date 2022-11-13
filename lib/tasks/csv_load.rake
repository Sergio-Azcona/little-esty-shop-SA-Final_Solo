require 'csv'

namespace :csv_load do

  task customers: :environment do 
    csv = CSV.open './db/data/customers.csv', headers: true, header_converters: :symbol
    csv.each do |row|
      Customer.create!(id: row[:id], first_name: row[:first_name], last_name: row[:last_name], created_at: row[:created_at], updated_at: row[:updated_at])
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end


  task merchants: :environment do 
    csv = CSV.read './db/data/merchants.csv', headers: true, header_converters: :symbol
    csv.each do |row|
      Merchant.create!(id: row[:id], name: row[:name], created_at: row[:created_at], updated_at: row[:updated_at])
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end
  
  task transactions: :environment do 
    csv = CSV.open './db/data/transactions.csv', headers: true, header_converters: :symbol
    csv.each do |row|
      row[:result] == 'success' ? result = 0 : result = 1
      Transaction.create!(
        id: row[:id],
        invoice_id: row[:invoice_id], 
        credit_card_number: row[:credit_card_number], 
        cc_expiration: row[:cc_expiration], 
        result: result, 
        created_at: row[:created_at], 
        updated_at: row[:updated_at]
      ) 
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  task invoices: :environment do 
    csv = CSV.open './db/data/invoices.csv', headers: true, header_converters: :symbol
    csv.each do |row|
      Invoice.create!(
        id: row[:id],
        customer_id: row[:customer_id],
        status: row[:status],
        created_at: row[:created_at],
        updated_at: row[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  task items: :environment do 
    csv = CSV.open './db/data/items.csv', headers: true, header_converters: :symbol
    csv.each do |row| 
      Item.create!(id: row[:id], name: row[:name], description: row[:description], unit_price: row[:unit_price], merchant_id: row[:merchant_id], created_at: row[:created_at], updated_at: row[:updated_at])
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task invoice_items: :environment do 
    csv = CSV.open './db/data/invoice_items.csv', headers: true, header_converters: :symbol
    csv.each do |row|
      InvoiceItem.create!(id: row[:id], item_id: row[:item_id], invoice_id: row[:invoice_id], quantity: row[:quantity], unit_price: row[:unit_price], status: row[:status], created_at: row[:created_at], updated_at: row[:updated_at])
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  task bulk_discounts: :environment do 
    
  end

  task all: :environment do 
    Rake::Task["csv_load:customers"].invoke 
    Rake::Task["csv_load:merchants"].invoke 
    Rake::Task["csv_load:invoices"].invoke 
    Rake::Task["csv_load:items"].invoke 
    Rake::Task["csv_load:transactions"].invoke 
    Rake::Task["csv_load:invoice_items"].invoke 

  end

  task delete_all: :environment do
    InvoiceItem.destroy_all
    Item.destroy_all
    Merchant.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Customer.destroy_all
  end


end
