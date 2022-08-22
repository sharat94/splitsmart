class CreateSettlements < ActiveRecord::Migration[6.0]
  def change
    create_table :settlements do |t|
      t.integer :payer_id
      t.integer :payee_id
      t.decimal :amount, precision: 10, scale: 2
      t.integer :group_id
      t.string :payment_mode

      t.timestamps
    end
  end
end
