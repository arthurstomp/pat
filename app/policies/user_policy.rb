class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def login?
    true
  end

  def create?
    true
  end

  def index?
    false
  end

  def show?
    user == record
  end
  alias_method :update?, :show?
  alias_method :destroy?, :show?
end
