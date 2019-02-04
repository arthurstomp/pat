class Employee < ApplicationRecord
  Roles = {admin: 'administrator', employee: 'employee'}

  default_scope { order(created_at: :desc) }
  belongs_to :company
  belongs_to :department
  belongs_to :user, inverse_of: :jobs

  validates :company_id, :department_id, presence: true
  validate :validate_role

  def admin?
    role == Roles[:admin]
  end

  private
  
  def validate_role
    unless Roles.values.include?(role)
      errors.add(:role, "not valid")
    end
  end
end
