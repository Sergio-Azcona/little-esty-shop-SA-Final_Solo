class InvoiceItem < ApplicationRecord
  enum status: { packaged: 0, pending: 1, shipped: 2 }
  belongs_to :invoice 
  belongs_to :item 
  has_many :bulk_discounts, through: :merchant
  has_one :merchant, through: :items


end