class SubmissionPolicy
  attr_accessor :user, :submission

  def initialize(user, submission)
    @user = user
    @submission = submission
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user: @user)
    end

    private
    
    attr_reader :user, :scope
  end

  def show?
    user.present? and (user.admin? or user == submission.user)
  end

  def create?
    user.present? and submission.problem.contest.is_open?
  end
end

