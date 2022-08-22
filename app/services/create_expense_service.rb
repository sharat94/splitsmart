class CreateExpenseService

  def record(params)
    amount = params[:amount].to_f

    split_type = params[:split_type]
    group_id = params[:group_id]
    group = Group.find group_id
    expense = Expense.create(amount: amount, split_type: split_type, group_id: group_id)

    paid_by = params[:paid_by]
    paid_by.each do |payer|
      expense.expense_payers.create(payer_id: payer[:user_id], amount: payer[:paid_amount])
    end

    users_owed = {}
    users_debts = {}
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

    users_owed.each do |payer_id, loan|
      users_debts.each do |payee_id, debt|
        if (loan + debt) > 0
          expense.expense_splits.create(payer_id: payer_id, payee_id: payee_id, split_by_value: nil, amount: debt.abs)
          loan += debt
          users_debts.delete(payee_id)
        elsif (loan + debt) <= 0
          expense.expense_splits.create(payer_id: payer_id, payee_id: payee_id, split_by_value: nil, amount: loan.abs)
          debt += loan
          loan = 0
          users_debts[payee_id] = debt
        end
        break if loan.zero? || (loan < 0 && loan > -1)
      end
    end
  end
end
