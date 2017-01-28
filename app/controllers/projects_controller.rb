class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.find(current_user.subscriptions.pluck(:project_id).uniq)
    redirect_to new_user_session_path unless current_user
  end

  # GET /projects/1
  def show
     begin
       @project = current_user.projects
         .joins(:subscriptions)
         .where(subscriptions: {user_id: current_user.id})
         .find(params[:id])
     rescue ActiveRecord::RecordNotFound => e
       redirect_to root_path, notice: 'No access to this project.'
     end
   end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    begin
      @project = current_user.projects
        .joins(:subscriptions)
        .where(subscriptions: {user_id: current_user.id})
        .find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to root_path, notice: 'No access to this project.'
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    @project.subscriptions.new(user: current_user)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:user_id, :title, :body)
    end

end
