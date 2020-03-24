require 'test_helper'

class ContestsControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get "#index"
    assert_template :index
  end

  test "show" do
    contest = contests(:default)
    get "#{contest_path contest}#show"
    assert_template :show
  end
end
