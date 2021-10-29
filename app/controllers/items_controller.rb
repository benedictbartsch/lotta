class ItemsController < ApplicationController
  include Pagy::Backend
  before_action :require_user!
  before_action :set_workspace
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    @project = @workspace.projects.find_by(name: params[:project]) if params[:project].present?
    
    if params[:tag]
      @items = @workspace.items.tagged_with([params[:tag]]).order(created_at: :desc)
    elsif @project
      @items = @workspace.items.where(project: @project).order(created_at: :desc)
    else
      @items = @workspace.items.all.order(created_at: :desc)
    end

    if params[:filter] == 'completed'
      @items = @items.where(status: 1)
    elsif params[:filter] == 'incomplete'
      @items = @items.where(status: 0).where(item_type: :task)
    elsif params[:filter] == 'tasks'
      @items = @items.where(item_type: :task)
    end

    if params[:search]
      @items = @workspace.items.where('content like ?', "%#{params[:search]}%")
    end

    @pagy, @items = pagy(@items, items: 30)
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = @workspace.items.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = @workspace.items.new(item_params)
    

    respond_to do |format|

      if @item.save

        @tags if @item.has_tags?

        format.turbo_stream
        format.html { redirect_to workspace_item_path(@workspace, @item), notice: "Item was successfully created." }
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
        format.html { redirect_to workspace_items_path(@workspace), notice: "Item was successfully updated." }
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
      format.html { redirect_to workspace_items_path(@workspace), notice: "Item was successfully destroyed." }
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
      params.require(:item).permit(:content, :item_type, :status)
    end

    def set_workspace
      # binding.irb
      @workspace = current_user.workspaces.find(params[:workspace_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to workspace_items_path(current_user.workspaces.first)
    end
end
