require 'test_helper'

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "missing parameters" do
    submission = Submission.new
    assert_not submission.save
  end
end
