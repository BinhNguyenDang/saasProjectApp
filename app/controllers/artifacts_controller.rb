class ArtifactsController < ApplicationController
  before_action :set_artifact, only: %i[ show edit update destroy ]

  # GET /artifacts or /artifacts.json
  def index
    @project = Project.find(params[:project_id])
    @artifacts = @project.artifacts
  end

  # GET /artifacts/1 or /artifacts/1.json
  def show
    @artifact = Artifact.find(params[:id])
    @project = @artifact.project
  end

  # GET /artifacts/new
  def new
    @project = Project.find(params[:project_id])
    @artifact = @project.artifacts.new
  end

  # GET /artifacts/1/edit
  def edit
    @artifact = Artifact.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  # POST /artifacts or /artifacts.json
  def create
    @project = Project.find(params[:project_id])
    @artifact = @project.artifacts.new(artifact_params)

    respond_to do |format|
      if @artifact.save
        format.html { redirect_to project_artifacts_url(@project), notice: "Artifact was successfully created." }
        format.json { render :show, status: :created, location: @artifact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artifacts/1 or /artifacts/1.json
  def update
    @artifact = Artifact.find(params[:id])
    @project = @artifact.project

    respond_to do |format|
      if @artifact.update(artifact_params)
        format.html { redirect_to artifact_url(@artifact), notice: "Artifact was successfully updated." }
        format.json { render :show, status: :ok, location: @artifact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artifacts/1 or /artifacts/1.json
  def destroy
    @artifact.destroy!

    respond_to do |format|
      format.html { redirect_to project_artifacts_url, notice: "Artifact was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def artifact_params
      params.require(:artifact).permit(:name, :project_id, :upload )
    end
end
