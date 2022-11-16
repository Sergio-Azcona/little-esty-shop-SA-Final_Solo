class Invoice < ApplicationRecord
  enum status: { cancelled: 0,  "in progress" => 1, completed: 2}
  belongs_to :customer 
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_one :merchant, through: :items
  has_many :bulk_discounts, through: :merchant

  def total_revenue #for an invoice 
    invoice_items.sum("quantity * unit_price")
  end

  def self.unshipped_items
    # require 'pry';binding.pry
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end

  def discount_calculation
    # require 'pry';binding.pry
  BulkDiscount.joins("JOIN invoices ON invoice_items.invoice_id = invoices.id 
  JOIN items ON invoice_items.item_id = items.id 
  JOIN merchants ON merchants.id = items.merchant_id 
  ").where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
  # sum('invoice_items.quantity * invoice_items.unit_price *(100.00-bulk_discounts.percentage)/100) AS discounted_revenue').
    # require 'pry';binding.pry
  end

  def discounted_charge
    Invoice.select("invoice_items.quantity * invoice_items.unit_price *(100-bulk_discounts.percentage)/100) AS discounted_charge")
  end

  def invoice_discounted_revenue
    # require 'pry';binding.pry
    invoice_items.joins(item: [merchant: :bulk_discounts])
    .select('MAX(invoice_items.quantity * invoice_items.unit_price *(bulk_discounts.percentage)/100) AS discounted_charge')
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    
    # .group('invoice_items.id') 
    # .order('invoices.id, discounted_charge ASC')
    # require 'pry';binding.pry
  end

  def qualify_for_discount_calculation
  end
end