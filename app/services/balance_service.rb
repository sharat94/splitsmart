class BalanceService
  attr_reader :current_user_id

  def initialize(user_id)
    @current_user_id = user_id
  end

  def fetch
    calculate_balance
  end

  private

  def balances
    ExpenseSplit.joins("INNER JOIN users ON users.id = expense_splits.payer_id")
                .where(payee_id: current_user_id)
                .where.not(payer_id: current_user_id)
                .group(:payer_id, 'users.name')
                .sum('expense_splits.amount')
  end

  def inverse_balances
    ExpenseSplit.joins("INNER JOIN users ON users.id = expense_splits.payee_id")
                .where(payer_id: current_user_id)
                .where.not(payee_id: current_user_id)
                .group(:payee_id, 'users.name')
                .sum('expense_splits.amount')
  end

  def settlements
    Settlement.joins("INNER JOIN users ON users.id = settlements.payer_id")
              .where(payee_id: current_user_id)
              .group(:payer_id, 'users.name')
              .sum('settlements.amount')
  end

  def total_settlements
    inverse_balances.merge(settlements) { |_, inverse_balance, settlement| inverse_balance.to_f + settlement.to_f }
  end

  def calculate_balance
    user_balances = {}
    (total_settlements.keys + balances.keys).uniq.each do |user_data|
      user_balances[user_data] = balances[user_data].to_f - total_settlements[user_data].to_f
    end
    user_balances
  end

end