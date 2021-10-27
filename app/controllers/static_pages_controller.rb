class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to workspace_items_path(current_user.workspaces.first)
    else
      @user = User.new
    end
  end
end
