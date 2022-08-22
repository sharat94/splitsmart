# == Schema Information
#
# Table name: expense_payers
#
#  id         :bigint           not null, primary key
#  expense_id :integer
#  payer_id   :integer
#  amount     :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class ExpensePayerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
