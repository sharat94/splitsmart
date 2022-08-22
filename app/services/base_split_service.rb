class BaseSplitService
  attr_reader :amount, :split_type, :group_id, :paid_by, :group, :split_by
  attr_accessor :expense, :users_owed, :users_debts

  def initialize(params)
    @amount = params[:amount].to_f
    @split_type = params[:split_type]
    @group_id = params[:group_id]
    @paid_by = params[:paid_by]
    @group = Group.find(params[:group_id])
    @split_by = params[:split_by]
    @expense = nil
    @users_owed = {}
    @users_debts = {}
  end

  def record
    raise ArgumentError.new("Amount/Split type/Group id cannot be nil") if amount.nil? || split_type.nil? || group_id.nil? || paid_by.nil?

    paid_by_total = @paid_by.map{ |p| p[:paid_amount].to_f }.sum
    raise ArgumentError.new("Total amount doesnt match with split amounts") if amount != paid_by_total


    ActiveRecord::Base.transaction do
      create_expense
      record_expense_payers
      simplify_user_transaction
      create_expense_splits
    end
  end

  private

  def create_expense
    @expense = Expense.create(amount: amount, split_type: split_type, group_id: group.id)
  end

  def record_expense_payers
    paid_by.each do |payer|
      expense.expense_payers.create(payer_id: payer[:user_id], amount: payer[:paid_amount])
    end
  end

  def create_expense_splits
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