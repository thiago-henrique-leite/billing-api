# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UNIVERSITIES = %w[UniFCV Unip Anhanguera Mackenzie PUC Metodista Uninove FGV FAAP Insper].freeze

ActiveRecord::Base.transaction do
  10.times do |index|  
    institution = Institution.create!(
      name: UNIVERSITIES[index], 
      cnpj: CNPJ.generate, 
      kind: :university
    )

    student = Student.create!(
      cpf: CPF.generate,
      gender: %w[M F].sample,
      postal_code: "23078-002",
      name: FFaker::NameBR.name,
      payment_method: %w[boleto card].sample,
      phone: FFaker::PhoneNumberBR.mobile_phone_number,
      address_number: Faker::Number.between(from: 1, to: 2000),
      birthday: Faker::Date.between(from: '1990-01-01', to: '2002-01-01')
    )

    enrollment = Enrollment.create!(
      student_id: student.id,
      institution_id: institution.id,
      enrollment_semester: '2022.1',
      course_name: "Curso #{index+1}",
      due_day: Faker::Number.between(from: 1, to: 31),
      amount_bills: Faker::Number.between(from: 1, to: 10),
      discount_percentage: Faker::Number.between(from: 1, to: 100),
      total_value: Faker::Number.decimal(l_digits: 4, r_digits: 2)
    )
  end
end