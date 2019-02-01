class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(id: user.connected_to_companies)
    end
  end

  def index?
    true
  end

  def show?
    user_has_connection_to_company?
  end

  def create?
    true
  end

  def update?
    user_owns_company?
  end
  alias_method :destroy?, :update?

  private

  def user_owns_company?
    user.owned_companies.include? record
  end

  def user_has_connection_to_company?
    user.connected_to_companies.include? record
  end
end
