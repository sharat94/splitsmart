# == Schema Information
#
# Table name: settlements
#
#  id           :bigint           not null, primary key
#  payer_id     :integer
#  payee_id     :integer
#  amount       :decimal(10, 2)
#  group_id     :integer
#  payment_mode :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Settlement < ApplicationRecord
end
