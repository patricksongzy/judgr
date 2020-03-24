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
    raise Pundit::NotAuthorizedError, "users.must_log_in" unless user.present?
    raise Pundit::NotAuthorizedError, "users.unauthorized" unless (user.admin? or user == submission.user)

    true
  end

  def create?
    raise Pundit::NotAuthorizedError, "users.must_log_in" unless user.present?
    raise Pundit::NotAuthorizedError, "contests.must_be_open" unless submission.problem.contest.is_open?
    raise Pundit::NotAuthorizedError, "users.request_limit_reached" unless (Time.now.to_i - (user.last_request || 0) > 60)
    
    true
  end
end

