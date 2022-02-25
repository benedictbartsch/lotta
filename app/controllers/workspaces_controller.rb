class WorkspacesController < ApplicationController
    before_action :set_workspace, except: ["new", "create"]

    def new
        @workspace = current_user.workspaces.build
    end
    
    def show
        
    end

    def create
        @workspace = current_user.workspaces.new(workspace_params)
    
        respond_to do |format|
          if @workspace.save
            format.html { redirect_to account_path }
            format.json { render :show, status: :created, location: @workspace }
    
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @workspace.errors, status: :unprocessable_entity }
    
          end 
        end
      end

    def edit

    end

    def update
        respond_to do |format|
        if @workspace.update(workspace_params)
            format.html { redirect_to account_path, notice: 'Workspace was successfully updated.' }
            format.json { render :show, status: :ok, location: @workspace }
    
        else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @workspace.errors, status: :unprocessable_entity }
    
        end
    end
    end


    def set_workspace
        @workspace = current_user.workspaces.find(params[:id])
    end

    def workspace_params
        params.require(:workspace).permit(:name)
    end
  
end
