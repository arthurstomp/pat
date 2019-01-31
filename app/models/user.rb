class User < ApplicationRecord
  has_many :jobs,
    class_name: "Employee",
    dependent: :destroy

  has_many :owned_companies,
    class_name: "Company",
    dependent: :destroy
  has_many :owned_departments,
    source: :departments,
    through: :owned_companies

  has_many :admin_of_companies, -> {
      where(employees: {role: Employee::Roles[:admin]})
    }, source: :company,
    through: :jobs
  has_many :employee_of_companies,
    source: :company,
    through: :jobs

  has_many :admin_of_departments, -> {
      where(employees: {role: Employee::Roles[:admin]})
    }, source: :department,
    through: :jobs
  has_many :employee_of_departments,
    source: :department,
    through: :jobs

  validates :email, :username, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def owner?(structure)
    case structure
    when Company
      owned_companies.include?(structure)
    when Department
      owned_departments.include?(structure)
    else
      false
    end
  end

  def admin?(structure)
    case structure
    when Company
       owner?(structure)||
        admin_of_companies.include?(structure)
    when Department
      owner?(structure) ||
        admin_of_departments.include?(structure)
    else
      false
    end
  end

  def member?(structure)
    case structure
    when Company
       admin?(structure)||
        employee_of_companies.include?(structure)
    when Department
      admin?(structure) ||
        employee_of_departments.include?(structure)
    else
      false
    end
  end

  def claim
    {email: email, username: username}
  end
end
