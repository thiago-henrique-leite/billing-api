class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.references :institution, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :enrollment_semester
      t.string :course_name
      t.integer :amount_bills
      t.integer :due_day
      t.decimal :total_value
      t.decimal :discount_percentage
      t.boolean :enabled, default: 'true'

      t.timestamps
    end
  end
end
