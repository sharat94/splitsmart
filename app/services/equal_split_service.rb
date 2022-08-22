class EqualSplitService < BaseSplitService

  def simplify_user_transaction
    group.users.each do |user|
      owed_share = (expense.amount / group.users.size).round(2)
      paid_share = expense.expense_payers.find_by(payer_id: user.id)&.amount&.round(2) || 0
      balance = paid_share - owed_share
      if balance > 0
        users_owed[user.id] = balance
      elsif balance < 0
        users_debts[user.id] = balance
      end
    end
  end
end