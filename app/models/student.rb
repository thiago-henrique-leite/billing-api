class Student < ApplicationRecord
  has_many :enrollments

  validates :cpf, cpf: true
  validates :postal_code, correios_cep: true
  validates :name, presence: { message: 'Student name not informed.' }
  validates :phone, presence: { message: 'Student phone not informed.' }
  validates :gender, inclusion: { in: %w[M F], message: 'Invalid gender.' }
  validates :payment_method, inclusion: { in: %w[card boleto], message: 'Invalid payment method.' }
  validates :address_number, numericality: { greater_than_or_equal_to: 0, message: 'Invalid address number.' }
  
  validate :cpf_must_be_uniq
  validate :birthday_must_be_valid

  before_create :format_cpf, :update_address
  before_destroy :destroy_student_enrollments
  before_update :update_address

  private

  def cpf_must_be_uniq
    student = Student.find_by(cpf: format_cpf)

    errors.add(:cpf, 'CPF already exists.') if student.present? && student != self
  end

  def birthday_must_be_valid
    errors.add(:birthday, 'Invalid date.') unless birthday.is_a?(Date)
  end
  
  def format_cpf
    self.cpf = CPF.new(self.cpf).formatted
  end

  def update_address
    address = Correios::CEP::AddressFinder.new.get(self.postal_code)

    self.city = address[:city]
    self.state = address[:state]
    self.neighborhood = address[:neighborhood]
    self.address = address[:address]
  end

  def destroy_student_enrollments
    self.enrollments.destroy_all
  end
end