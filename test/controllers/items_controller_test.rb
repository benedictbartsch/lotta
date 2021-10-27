require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
    @user = users(:lotta)
    @workspace = workspaces(:first)
    passwordless_sign_in(@user)
    @janes_workspace = workspaces(:second)
  end

  test "should get index" do
    get workspace_items_url(@workspace)
    assert_response :success
  end

  test "should get new" do
    get new_workspace_item_url(@workspace)
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post workspace_items_url(@workspace), params: { item: { content: @item.content } }
    end

    assert_redirected_to workspace_item_url(@workspace, Item.last)
  end

  test "should show item" do
    get workspace_item_url(@workspace, @item)
    assert_response :success
  end

  test "should get edit" do
    get edit_workspace_item_url(@workspace, @item)
    assert_response :success
  end

  test "should update item" do
    patch workspace_item_url(@workspace, @item), params: { item: { content: @item.content } }
    assert_redirected_to workspace_items_path(@workspace)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete workspace_item_url(@workspace, @item)
    end

    assert_redirected_to workspace_items_path(@workspace)
  end

  test "not logged in user should not be able to access items" do
    get workspace_items_path(@janes_workspace)
    assert_redirected_to workspace_items_path(@user.workspaces.first)
  end
end
