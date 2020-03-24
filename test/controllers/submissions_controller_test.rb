require 'test_helper'

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    submission = submissions(:default)
    get "#{submission_path submission}#show"
    assert_template :show
  end

  test "empty code" do
    start_count = Submission.count

    post submissions_path, headers: {"HTTP_COOKIE" => "remember_token=#{users(:default).remember_token}"}, params: {submission: {code_file: nil, problem_id: problems(:default).id}}

    expected = ["#{Language.model_name.human} #{I18n.t 'errors.messages.required'}", "#{User.model_name.human} #{I18n.t 'errors.messages.required'}"]
    assert expected.all? { |message| flash[:submission_error].include? message }
    assert Submission.count == start_count
  end

  test "missing parameters" do
    start_count = Submission.count

    post submissions_path, headers: {"HTTP_COOKIE" => "remember_token=#{users(:default).remember_token}"}, params: {submission: {code_file: nil, problem_id: problems(:default).id}}

    expected = ["#{Language.model_name.human} #{I18n.t 'errors.messages.required'}", "#{User.model_name.human} #{I18n.t 'errors.messages.required'}"]
    assert expected.all? { |message| flash[:submission_error].include? message }
    assert Submission.count == start_count
  end
end
