class DepartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(id: @user.connected_to_departments)
    end
  end

  def index?
    true
  end

  def show?
    user_has_connection_to_department?
  end

  def create?
    user.owned_companies.count != 0
  end

  def update?
    user_owns_department?
  end
  alias_method :destroy?, :update?

  private

  def user_has_connection_to_department?
    user.connected_to_departments.include? record
  end

  def user_owns_department?
    user.owned_departments.include? record
  end
end
