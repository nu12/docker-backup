require "test_helper"

class RecoverControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recover_index_url
    assert_response :success
  end

  test "should get new" do
    get recover_new_url
    assert_response :success
  end

  test "should get create" do
    get recover_create_url
    assert_response :success
  end
end
