class Bill < ApplicationRecord
  include AASM

  belongs_to :enrollment

  validates :due_date, presence: true
  validates :full_amount, numericality: { greater_than: 0, message: 'Invalid full amount.' }
  validates :status, inclusion: { in: ['open', 'pending', 'paid', 'canceled', 'ignored'], message: 'Invalid status.' }
  validates :bill_type, inclusion: { in: ['installment', 'agreement'], message: 'Invalid bill type.' }

  after_update :update_enrollment_bill
  after_destroy :update_enrollment_bill

  aasm column: :status, whiny_persistence: true do 
    state :open, initial: true
    state :pending
    state :paid
    state :canceled
    state :ignored

    event :pay do
      transitions from: %i[open pending], to: :paid
    end

    event :cancel do
      transitions from: %i[open pending], to: :canceled
    end

    event :ignore do
      transitions from: %i[open pending], to: :ignored
    end
  end

  private 

  def update_enrollment_bill
    self.enrollment.update_total_value!
    self.enrollment.update_amount_bills!
  end
end