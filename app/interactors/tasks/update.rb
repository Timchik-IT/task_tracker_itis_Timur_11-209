module Tasks 
  class Update
    include Interactor

    delegate :task_params, :task, to: :context

    def call
      context.fail!(error: "Task not updated") unless task.update(task_params)
      context.notice = "Task successfully updated"
    end
  end
end