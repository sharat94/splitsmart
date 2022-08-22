class CreateExpensePayers < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_payers do |t|
      t.integer :expense_id
      t.integer :payer_id
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
