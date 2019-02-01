class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.where(company: user.employee_of_companies)
      else
        scope.none
      end
    end
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? ||
      record_belongs_to_user
  end
  alias_method :update?, :show?
  alias_method :destroy?, :show?

  def create?
    user.admin?
  end

  private

  def record_belongs_to_user
    user.jobs.include? record
  end
end
