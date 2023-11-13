require "rails_helper"

describe Projects::Update do
  describe ".call" do
    let(:project) { create :project }
    let(:interactor) { described_class.new(project: project, project_params: params) }

    context "when params are valid" do
      let(:params) do
        {
          name: "new name",
          description: "new description"
        }
      end

      it "project successfuly update" do
        interactor.run

        expect(project.name).to eq params[:name]
        expect(project.description).to eq params[:description]
      end
    end

    context "when params are invalid" do
      let(:params) do
        {
          name: "",
          description: "new description"
        }
      end

      let(:expected_error_message) { "Invalid data" }

      it "throws error" do
        interactor.run

        expect(interactor.context.error).to eq(expected_error_message)
      end
    end
  end
end
