class CreateExpenseSplits < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_splits do |t|
      t.integer :payer_id
      t.integer :payee_id
      t.integer :expense_id
      t.decimal :split_by_value, precision: 10, scale: 2
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
