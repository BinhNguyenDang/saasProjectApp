class ProjectsController < ApplicationController
  # Set the project and authorize the member before specified actions
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authorize_member, only: %i[ show edit update destroy ]

  # GET /projects or /projects.json
  # List all projects associated with the current user
  def index
    @projects = current_user.projects
    # show errer if you don't have tenant of 
    rescue ActsAsTenant::Errors::NoTenantSet
      flash[:alert] = "You do not have a tenant. Please set a tenant before access."
      redirect_to root_path
  end

  # GET /projects/1 or /projects/1.json
  # Show details of a specific project
  def show
  end

  # GET /projects/new
  # Initialize a new project object
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  # Initialize the edit form for a specific project
  def edit
  end

  # POST /projects or /projects.json
  # Create a new project
  def create
    @project = Project.new(project_params)
    @project.plan = 'free'

    respond_to do |format|
      if @project.save
        # Add the current user as an admin member of the project
        @project.members.create(user: current_user, roles: {admin: true})
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  # Update an existing project with new attributes
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  # Delete a project
  def destroy
    @project.members.destroy_all # Delete associated members

    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    # Attempts to find a project by its ID and assigns it to the @project instance variable.
    @project = Project.find(params[:id])
    # Rescue block for handling the ActiveRecord::RecordNotFound exception.
    rescue ActiveRecord::RecordNotFound
      # Captures the project ID from the request parameters.
      project_id = params[:id]
      # Sets a flash alert message informing the user that the project with the specified ID was not found.
      flash[:alert] = "You do not have Project with Project ID #{project_id}."
      # Redirects the user to the projects index page.
      redirect_to projects_path
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:account_id, :name, :account_id, :name, :details, :expected_completion_date)
  end

  # Check project member authorization
  def authorize_member
    return redirect_to root_path, alert: 'You are not a member' unless @project.users.include? current_user
  end
end
