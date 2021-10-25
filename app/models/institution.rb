class Institution < ApplicationRecord
  has_many :enrollments

  validates :name, presence: { message: 'Institution name not informed.' }
  validates :kind, inclusion: { in: ['university', 'school', 'basic_school'], message: 'Invalid kind.' }
  validates :cnpj, cnpj: true
  
  validate :cnpj_must_be_uniq
  
  before_create :format_cnpj
  before_destroy :destroy_institution_enrollments

  private

  def cnpj_must_be_uniq
    institution = Institution.find_by(cnpj: format_cnpj)
    
    errors.add(:cnpj, 'CNPJ already exists.') if institution.present? && institution != self
  end

  def format_cnpj
    self.cnpj = CNPJ.new(self.cnpj).formatted
  end

  def destroy_institution_enrollments
    self.enrollments.destroy_all
  end
end
