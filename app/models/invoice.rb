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
    Invoice.select("invoices.*").joins(:invoice_items).where(status: [0,1]).group("invoices.id").order("created_at ASC") 
  end

  def discount_calculation
    BulkDiscount.where('invoice_items.quantity >= bulk_discounts.quantity_threshold').sum('invoice_items.quantity * invoice_items.unit_price *(100.00-bulk_discounts.percentage)/100) AS discounted_revenue') 
  
  end

  def discounted_charge
    Invoice.select("invoice_items.quantity * invoice_items.unit_price *(100-bulk_discounts.percentage)/100) AS discounted_charge")
  end

  def invoice_discounted_revenue
    x = invoice_items.joins(:bulk_discounts)
    .select('invoices.id AS invoice_id, (invoice_items.quantity * invoice_items.unit_price *(100-bulk_discounts.percentage)/100) AS discounted_charge')
    .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
    .group('invoice_items.id') 
    .order('invoices.id, discounted_charge ASC')
    # require 'pry';binding.pry
  end

  def qualify_for_discount_calculation
  end
end