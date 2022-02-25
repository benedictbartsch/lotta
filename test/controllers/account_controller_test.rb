require 'test_helper'

class AccountControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:lotta)
    passwordless_sign_in(@user)
  end

  test 'should get index' do
    get account_url
    assert_response :success
  end
end
