# == Schema Information
#
# Table name: expense_splits
#
#  id             :bigint           not null, primary key
#  payer_id       :integer
#  payee_id       :integer
#  expense_id     :integer
#  split_by_value :decimal(10, 2)
#  amount         :decimal(10, 2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class ExpenseSplitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
