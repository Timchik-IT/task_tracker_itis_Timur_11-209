module Api
  module V1
    class ProjectsController < Api::ApplicationController
      before_action :set_project, only: %i[update destroy]
      def index
        @projects = Project.includes(:tasks)
                           .order(params[:sort])

        serializable_projects = ActiveModelSerializers::SerializableResource.new(
          @projects, each_serializer: ProjectSerializer
        )
        render json: { projects: serializable_projects }
      end

      def create
        @project = create_project.project
        if create_project.success?
          render json: { project: @project, message: "Project Created" }
        else
          render json: { project: {}, errors: @project.errors }
        end
      end

      def update
        @update_project = update_project
        if @update_project.success?
          render json: { project: @project, message: "Project updated" }
        else
          render json: { project: {}, errors: @project.errors }
        end
      end

      def destroy
        @destroy_project = destroy_project
        if @destroy_project.success?
          render json: { project: @project, message: "Project updated" }
        else
          render json: { project: {}, errors: @project.errors }
        end
      end

      private

      def set_project
        @project = Project.find_by(id: params[:id])
      end

      def destroy_project
        @destroy_project ||=
          Projects::Destroy.call(project: @project)
      end

      def update_project
        @update_project ||=
          Projects::Update.call(project: @project, project_params: project_params)
      end

      def create_project
        @create_project ||=
          Projects::Create.call(project_params: project_params, user: current_user)
      end

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
