class Employee < ApplicationRecord
  Roles = {admin: 'administrator', employee: 'employee'}
  belongs_to :company
  belongs_to :department
  belongs_to :user

  validates :name, :company_id, :department_id, presence: true
  validates :user_id, uniqueness: true
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
