class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.string :status
      t.date :due_date
      t.decimal :full_amount
      t.string :bill_type, default: 'installment'

      t.timestamps
    end
  end
end
