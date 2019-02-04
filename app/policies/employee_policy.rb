class EmployeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    true
  end

  def show?
    record_belongs_to_user? ||
      record.company.user_is_admin?(user)
  end
  alias_method :update?, :show?
  alias_method :destroy?, :show?

  def create?
    user.admin?
  end

  private

  def record_belongs_to_user?
    record.user == user
  end
end
