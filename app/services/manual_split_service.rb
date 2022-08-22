class ManualSplitService < BaseSplitService

  def simplify_user_transaction
    raise ArgumentError.new("Split by share doesnt add up to total amount") if amount != split_by.map{ |s| s[:value].to_f }.sum

    group.users.each do |user|
      owed_share = split_by.detect{ |u| u[:user_id] == user.id }[:value]
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