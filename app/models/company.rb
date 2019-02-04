class Company < ApplicationRecord
  default_scope { order(created_at: :desc) }

  has_many :employees, dependent: :destroy
  has_many :departments, inverse_of: :company

  belongs_to :user, class_name: "User"

  validates :name, presence: true

  def job_of_user(user)
    employees.includes(:user).where(user: user)
  end

  def user_is_admin?(user)
    return true if user == self.user
    job_of_user(user).pluck(:role).include? "admin"
  end

  def user_is_just_member?(user)
    not user_is_admin?(user)
  end
end
