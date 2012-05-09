require "minitest_helper"

class UsersControllerTest < MiniTest::Rails::Controller

  def test_subscribe
    get :subscribe
    assert_response :success
  end

  def test_login
    get :login
    assert_response :success
  end

end
