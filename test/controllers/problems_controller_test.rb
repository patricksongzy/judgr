require 'test_helper'

class ProblemsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    problem = problems(:default)
    get "#{problem_path problem}#show"
    assert_template :show
  end
end
