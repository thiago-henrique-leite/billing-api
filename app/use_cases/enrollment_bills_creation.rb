class EnrollmentBillsCreation
  include UseCase
  
  attr_reader :enrollment, :first_due_date, :bill_value, :total_value_with_discount

  def initialize(enrollment)
    @enrollment = enrollment
  end
    
  def perform
    calculate_total_value_with_discount
    calculate_bill_value
    define_first_due_date
    create_enrollment_bills
  end

  private

  def calculate_total_value_with_discount
    @total_value_with_discount = enrollment.total_value * (100 - enrollment.discount_percentage) / 100
  end
  
  def calculate_bill_value
    @bill_value =  total_value_with_discount / enrollment.amount_bills
  end

  def define_first_due_date
    date = Date.today.day < enrollment.due_day ? Date.today : Date.today.next_month

    @first_due_date = build_due_date(date.year, date.month, enrollment.due_day)
  end

  def build_due_date(year, month, day)
    begin
      @first_due_date = Date.civil(year, month, day)
    rescue Date::Error => e
      @first_due_date = Date.civil(year, month, -1)
    end
  end

  def create_enrollment_bills
    enrollment.amount_bills.times do |index|
      Bill.create!(
        status: :open,
        bill_type: :installment,
        enrollment_id: enrollment.id,
        due_date: get_due_date(index),
        full_amount: bill_value.round(2)
      )
    end
  end

  def get_due_date(index)
    due_date = first_due_date + index.month

    return due_date if first_due_date.day == enrollment.due_day
      
    build_due_date(due_date.year, due_date.month, enrollment.due_day)
  end
end