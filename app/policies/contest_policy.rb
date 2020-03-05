class ContestPolicy 
  attr_accessor :user, :contest

  def initialize(user, contest)
    @user = user
    @contest = contest
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope.is_a?(Array) ? scope.last : scope
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
