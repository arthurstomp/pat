class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.admin_and_owned_companies
    end
  end

  def index?
    true
  end

  def show?
    user_has_connection_to_company?
  end

  def create?
    record.user = user
  end

  def update?
    user_owns_company?
  end
  alias_method :destroy?, :update?

  def report?
    record.user_is_admin?(user)
  end
  alias_method :departments, :report?

  private

  def user_owns_company?
    user.owned_companies.include? record
  end

  def user_has_connection_to_company?
    user.connected_to_companies.include? record
  end
end
