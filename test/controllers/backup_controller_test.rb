require "test_helper"

class BackupControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get backup_index_url
    assert_response :success
  end

  test "should get new" do
    get backup_new_url
    assert_response :success
  end

  test "should get create" do
    get backup_create_url
    assert_response :success
  end
end
