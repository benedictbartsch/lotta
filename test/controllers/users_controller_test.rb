require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:lotta)
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create user' do
    new_user_email = 'random@example.com'
    assert_difference('User.count', 1) do
      assert_difference('Workspace.count', 1) do
        post users_url, params: { user: { email: new_user_email } }, headers: { 'HTTP_USER_AGENT' => 'Minitest' }
      end
    end

    assert_equal new_user_email, User.last.email

    assert_redirected_to workspace_items_url(Workspace.last)
  end
end
