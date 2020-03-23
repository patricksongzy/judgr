class Admin::ProblemPolicy
  attr_accessor :user, :contest

  def initialize(user, contest)
    @user = user
    @contest = contest
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
