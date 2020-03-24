require 'test_helper'

class ProblemTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @problem = problems(:default)
  end

  def test_admin_ancestors
    ancestors = @problem.get_ancestors(true)
    contest = @problem.contest
    assert ancestors == [[@problem.name, edit_admin_contest_problem_path(contest, @problem)], [contest.name, edit_admin_contest_path(contest)], [Contest.model_name.human(count: :many), admin_contests_path]]
  end
end
