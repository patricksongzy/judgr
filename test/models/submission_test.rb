require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @submission = submissions(:default)
  end

  def test_ancestors
    ancestors = @submission.get_ancestors(false)
    problem = @submission.problem
    contest = problem.contest
    assert ancestors == [[@submission.get_name, submission_path(@submission)], [problem.name, problem_path(problem)], [contest.name, contest_path(contest)], ["Contests", contests_path]]
  end
end
