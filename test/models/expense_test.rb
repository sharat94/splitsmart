# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  amount     :decimal(10, 2)
#  date       :datetime
#  group_id   :integer
#  deleted_at :datetime
#  deleted_by :integer
#  split_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
