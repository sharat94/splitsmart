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
class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
end
