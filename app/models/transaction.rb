class Transaction < ApplicationRecord
  enum result: { success: 0, failed: 1 }
  belongs_to :invoice 
  has_many :bulk_discounts, through: :invoice
  has_many :transactions, through: :invoice

end