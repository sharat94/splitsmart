class Api::V1::BalancesController < Api::ApiController

  def index
    balances = ExpenseSplit.joins("INNER JOIN users ON users.id = expense_splits.payer_id")
                           .where(payee_id: @current_user.id)
                           .where.not(payer_id: @current_user.id)
                           .group(:payer_id, 'users.name')
                           .sum('expense_splits.amount')
    settlements = Settlement.joins("INNER JOIN users ON users.id = settlements.payer_id")
                            .where(payee_id: @current_user.id)
                            .group(:payer_id, 'users.name')
                            .sum('settlements.amount')
    total_balance = balances.merge(settlements) { |_, balance, settlement| balance - settlement }

    render json: total_balance
  end
end
