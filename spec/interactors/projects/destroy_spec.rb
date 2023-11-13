require "rails_helper"

describe Projects::Destroy do
  describe ".call" do 
    it 'destroys the project' do
      project = create(:project)

      expect { described_class.call(project: project)}
          .to change { Project.count }.by(-1)
    end
  end
end
