class User < ApplicationRecord
  default_scope { order(created_at: :desc) }

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

  def admin_and_owned_companies
    admin_ids = admin_of_companies.pluck(:id)
    owned_ids = owned_companies.pluck(:id)
    merged_ids = (admin_ids + owned_ids).uniq

    Company.where(id: merged_ids)
  end
  
  def connected_to_companies
    owned_ids = owned_companies.pluck(:id)
    employed_ids = employee_of_companies.pluck(:id)
    connected_ids = (owned_ids + employed_ids).uniq

    Company.where(id: connected_ids)
  end

  def connected_to_departments
    owned_ids = owned_departments.pluck(:id)
    employed_ids = employee_of_departments.pluck(:id)
    connected_ids = (owned_ids + employed_ids).uniq

    Department.where(id: connected_ids)
  end

  def owner_of?(structure)
    case structure
    when Company
      owned_companies.include?(structure)
    when Department
      owned_departments.include?(structure)
    else
      false
    end
  end

  def admin?
    owned_companies.count != 0 ||
      admin_of_companies.count != 0 ||
      admin_of_departments.count != 0
  end

  def admin_of?(structure)
    case structure
    when Company
       owner_of?(structure)||
        admin_of_companies.include?(structure)
    when Department
      owner_of?(structure) ||
        admin_of_departments.include?(structure)
    else
      false
    end
  end

  def member_of?(structure)
    case structure
    when Company
       admin_of?(structure)||
        employee_of_companies.include?(structure)
    when Department
      admin_of?(structure) ||
        employee_of_departments.include?(structure)
    else
      false
    end
  end

  def claim
    {email: email, username: username}
  end

  def jwt
    JWT.encode claim,
      Pat::Application.config.jwt_auth[:secret],
      Pat::Application.config.jwt_auth[:alg]
  end

  def request_builder(request = {})
    FrontMakeup::User.new self, request
  end
end
