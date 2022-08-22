class Api::V1::ExpensesController < Api::ApiController

  def index
    expenses = Expense.joins(:expense_splits)
                      .where("expense_splits.payer_id = ? OR expense_splits.payee_id = ?",
                             @current_user.id,
                             @current_user.id)
                      .distinct

    render json: expenses
  end

  def create
    CreateExpenseService.new.record(params)
    render json: { success: true}
  end
end
