class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant 

  def most_recent_date
    invoices.order(created_at: :desc).limit(1).pluck(:created_at)
  end
end