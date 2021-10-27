require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:lotta)
  end

  test 'should get home' do
    get root_url
    assert_response :success
  end

  test 'should redirect to workspace if logged in' do
    passwordless_sign_in(@user)
    get root_url
    assert_redirected_to workspace_items_url(@user.workspaces.first)
  end
end
