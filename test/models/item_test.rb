require "test_helper"

class ItemTest < ActiveSupport::TestCase

  setup do
    @workspace = workspaces(:first)
  end

  test "content should be present" do
    item = @workspace.items.build
    assert_not item.valid?
    item.content = ''
    assert_not item.valid?
    item.content = 'Yes, this is dog.'
    assert item.valid?
  end
end
