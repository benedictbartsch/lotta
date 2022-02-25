class GroupsController < ApplicationController
  include Pagy::Backend
  before_action :require_user!
  before_action :set_workspace

  def show
    @group = @workspace.groups.find(params[:id])
    @items = @group.items.order(created_at: :desc)
    @pagy, @items = pagy(@items, items: 30)
    render 'items/index'
  end

  def edit
    @group = @workspace.groups.find(params[:id])
  end

  def update
    @group = @workspace.groups.find(params[:id])

    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to workspace_group_path(@workspace, @group), notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }

      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }

      end 
    end
  end

  def create
    @group = @workspace.groups.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to workspace_group_path(@workspace, @group) }
        format.json { render :show, status: :created, location: @group }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }

      end 
    end
  end

  private

  def set_workspace
    @workspace = current_user.workspaces.find(params[:workspace_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workspace_items_path(current_user.workspaces.first)
  end

  def group_params
    params.require(:group).permit(:name)
  end
end