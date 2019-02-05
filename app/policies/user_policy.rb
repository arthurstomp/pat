class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def login?
    true
  end

  def create?
    true
  end

  def show?
    user.id == record.id
  end
  alias_method :update?, :show?
  alias_method :destroy?, :show?
end
