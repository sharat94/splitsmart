# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  description       :text
#  simplify_debts_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
