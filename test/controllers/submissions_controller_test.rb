require 'test_helper'

class SubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    submission = submissions(:default)
    get "#{submission_path submission}#show", headers: {"HTTP_COOKIE" => "remember_token=#{users(:default).remember_token}"}
    assert_template :show
  end

  test "unauthorized show" do
    submission = submissions(:default)
    get "#{submission_path submission}#show"
    assert flash[:application_error] == I18n.t('pundit.users.must_log_in')
  end

  test "empty code" do
    start_count = Submission.count

    post submissions_path, headers: {"HTTP_COOKIE" => "remember_token=#{users(:default).remember_token}"}, params: {submission: {code_file: nil, problem_id: problems(:default).id}}

    assert flash[:submission_error] == ["#{Submission.model_name.human} #{I18n.t('submissions.form.errors.required')}"]
    assert Submission.count == start_count
  end

  test "missing parameters" do
    start_count = Submission.count

    post submissions_path, headers: {"HTTP_COOKIE" => "remember_token=#{users(:default).remember_token}"}, params: {submission: {code_file: nil, problem_id: problems(:default).id}}

    assert flash[:submission_error] == ["#{Submission.model_name.human} #{I18n.t('submissions.form.errors.required')}"]
    assert Submission.count == start_count
  end
end
