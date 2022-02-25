class ItemsController < ApplicationController
  include Pagy::Backend
  before_action :require_user!
  before_action :set_workspace
  before_action :set_item, only: %i[show edit update destroy]

  # GET /items or /items.json
  def index
    @project = @workspace.projects.find_by(name: params[:project]) if params[:project].present?

    @items = if params[:tag]
               @workspace.items.tagged_with([params[:tag]])
             elsif @project
               @workspace.items.where(project: @project)
             else
               @workspace.items.includes(:group)
             end

    if params[:filter] == 'completed'
      @items = @items.where(status: 1).where(item_type: :task)
    elsif params[:filter] == 'incomplete'
      @items = @items.where(status: 0).where(item_type: :task)
    elsif params[:filter] == 'due'
      @items = @items.where.not(due_at: nil)
    elsif params[:filter] == 'tasks'
      @items = @items.where(status: 0).where(item_type: :task)
    end

    @items = @workspace.items.where('lower(content) like ?', "%#{params[:search].downcase}%") if params[:search]
    
    @items = if params[:sorting] == "created_at_asc"
              @items.order(created_at: :asc)
            elsif params[:sorting] == "updated_at_desc"
              @items.order(updated_at: :desc)
            elsif params[:sorting] == "updated_at_desc"
              @items.order(updated_at: :desc)
            elsif params[:sorting] == "due_at_asc"
              @items.order(due_at: :asc).order(created_at: :desc)
            else
              @items.order(created_at: :desc)
            end
    
    

    @pagy, @items = pagy(@items, items: 30)
  end

  # GET /items/1 or /items/1.json
  def show; end

  def group
    @group = @workspace.groups.find(params[:group_id])
    @items = @group.items.order(created_at: :desc)
    @pagy, @items = pagy(@items, items: 30)
    render 'index'
  end

  # GET /items/new
  def new
    @item = @workspace.items.new
    @group = @workspace.groups.find(params[:group_id]) if params[:group_id].present?
  end

  # GET /items/1/edit
  def edit; end

  # POST /items or /items.json
  def create
    @item = @workspace.items.new(item_params)

    respond_to do |format|
      if @item.save

        @tags if @item.has_tags?
        @group = @item.group

        format.turbo_stream
        format.html { redirect_to workspace_item_path(@workspace, @item), notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        @group = @item.group

        format.html { redirect_to workspace_items_path(@workspace), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to workspace_items_path(@workspace), notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = @workspace.items.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:content, :item_type, :status, :group_id, :due_at)
  end

  def set_workspace
    # binding.irb
    @workspace = current_user.workspaces.find(params[:workspace_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to workspace_items_path(current_user.workspaces.first)
  end
end
