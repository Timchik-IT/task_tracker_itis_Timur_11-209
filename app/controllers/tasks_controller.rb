class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show edit update destroy]
  before_action -> { authorize! @task }, only: %i[edit update show destroy]

  def index
    @task = Task.new(project: @project)
    authorize! @task

    @tasks = @project.tasks.order(params[:sort]).page(params[:page]).per(3)
  end

  def show; end

  def new
    @task = @project.tasks.build
    @task.deadline_at ||= 1.week.from_now

    authorize! @task
  end

  def edit; end

  def create
    @task = create_task.task
    authorize! @task

    if create_task.success?
      redirect_to project_tasks_path(@project), notice: "Task successfully created!"  
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @task = update_task

    if @task.success?
      redirect_to project_tasks_path(@project), notice: @task.notice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = destroy_task

    if @task.success?
      redirect_to project_tasks_path(@project), notice: @task.notice
    else
      redirect_to project_tasks_path(@project), alert: @task.error
    end
  end

  private

  def set_project
    @project = Project.find_by(id: params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status, :deadline_at)
  end

  def create_task
    @create_task ||= ::Tasks::Create.call(params: params, project: @project)
  end

  def destroy_task
    @destroy_task ||= ::Tasks::Destroy.call(task: @task)                                            
  end

  def update_task
    @update_task ||= ::Tasks::Updater.call(task: @task,
                                          params: params)
  end
end
