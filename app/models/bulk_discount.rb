class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of  :percentage, :quantity_threshold
  validates_numericality_of :percentage, :quantity_threshold


def discount_calculation
  BulkDiscount.where('invoice_items.quantity >= bulk_discounts.quantity_threshold').sum('invoice_items.quantity * invoice_items.unit_price *(100.00-bulk_discounts.percentage)/100) AS discounted_revenue') 

end

end