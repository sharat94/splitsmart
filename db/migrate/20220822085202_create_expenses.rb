class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.timestamp :date
      t.integer :group_id
      t.timestamp :deleted_at
      t.integer :deleted_by
      t.string :split_type

      t.timestamps
    end
  end
end
