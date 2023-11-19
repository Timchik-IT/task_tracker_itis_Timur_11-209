module Comments
  class Destroy
    include Interactor

    delegate :comment, to: :context

    def call
      context.fail!(error: "Comment didn't delete") unless comment.destroy
      context.notice = "Comment successfully deleted"
    end
  end
end
