class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.admin_and_owned_companies
    end
  end

  def index?
    true
  end

  def create?
    record.user = user
  end
  alias_method :destroy?, :create?

  def show?
    user_is_admin?
  end
  alias_method :update?, :show?
  alias_method :report?, :show?
  alias_method :departments?, :show?

  private

  def user_is_admin?
    record.user_is_admin? user
  end
end
