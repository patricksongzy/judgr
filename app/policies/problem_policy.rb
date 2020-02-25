class ProblemPolicy
  attr_accessor :user, :problem

  def initialize(user, problem)
    @user = user
    @problem = problem
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

    private

    attr_reader :user, :scope
  end

  def show?
    true
  end
end
