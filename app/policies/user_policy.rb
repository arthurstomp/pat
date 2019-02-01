class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.none
    end
  end

  def index?
    false
  end

  def show?
    user == record
  end
  alias_method :update?, :show?
  alias_method :destroy?, :show?

  def create?
    true
  end
end
