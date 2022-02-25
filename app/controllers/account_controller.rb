class AccountController < ApplicationController
  before_action :require_user!

  def show
    @workspaces = current_user.workspaces
  end
  
end
