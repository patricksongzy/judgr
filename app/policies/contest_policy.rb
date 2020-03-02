class ContestPolicy 
  attr_accessor :user, :contest

  def initialize(user, contest)
    @user = user
    @contest = contest
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

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    true
  end
end
