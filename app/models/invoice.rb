class Invoice < ApplicationRecord
  enum status: { cancelled: 0,  "in progress" => 1, completed: 2}
  belongs_to :customer 
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  
  
  def total_revenue #for an invoice item
    invoice_items.sum("quantity * unit_price")
  end
  
end