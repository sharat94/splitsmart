# == Schema Information
#
# Table name: user_groups
#
#  id         :bigint           not null, primary key
#  user_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
