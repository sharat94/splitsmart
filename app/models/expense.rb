class Expense < ApplicationRecord
  has_many :expense_splits
  has_many :expense_payers

end
