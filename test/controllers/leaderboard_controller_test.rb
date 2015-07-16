require 'test_helper'

class LeaderboardControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get projects" do
    get :projects
    assert_response :success
  end

end
