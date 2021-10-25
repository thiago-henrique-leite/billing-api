class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :cpf
      t.date :birthday
      t.string :gender
      t.string :phone
      t.string :payment_method
      t.string :postal_code
      t.string :state
      t.string :city
      t.string :address
      t.string :neighborhood
      t.string :address_number
      t.boolean :enabled, default: 'true'

      t.timestamps
    end
  end
end
