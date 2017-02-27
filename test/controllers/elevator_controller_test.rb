require 'test_helper'

class ElevatorControllerTest < ActionController::TestCase
  test "should get init" do
    get :init
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
