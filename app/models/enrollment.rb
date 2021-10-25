class Enrollment < ApplicationRecord
  belongs_to :institution
  belongs_to :student

  has_many :bills

  validates :course_name, presence: { message: 'Course not informed.' }
  validates :total_value, numericality: { greater_than: 0, message: 'Invalid total value.' }
  validates :due_day, numericality: { greater_than: 0, less_than: 32, message: 'Invalid due day.' }
  validates :amount_bills, numericality: { greater_than: 0, message: 'Invalid amount bills.' }
  
  validates :discount_percentage, numericality: { 
    greater_than_or_equal_to: 0, 
    less_than_or_equal_to: 100, 
    message: 'Invalid discount_percentage.' 
  }
  
  validate :enrollment_semester_must_be_valid

  after_create :create_enrollment_bills
  before_destroy :destroy_enrollment_bills

  def update_total_value!
    self.update!(total_value: self.bills.sum{ |bill| bill.full_amount })
  end

  def update_amount_bills!
    self.update!(amount_bills: self.bills.size)
  end

  private

  def enrollment_semester_must_be_valid
    errors.add(:enrollment_semester, 'Invalid format.') unless /^\d{4}\.\d{1,2}$/.match?(enrollment_semester)
  end

  def create_enrollment_bills
    EnrollmentBillsCreation.perform(self)
  end

  def destroy_enrollment_bills
    self.bills.destroy_all
  end
end