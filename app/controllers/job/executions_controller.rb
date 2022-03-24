# frozen_string_literal: true
module Job
  class ExecutionsController < BaseController

    def index
      q_params = {}
      q_params.merge! params.permit!

      @executions = GoodJob::Execution.default_where(q_params).page(params[:page])
    end

    def destroy
      deleted_count = GoodJob::Execution.where(id: params[:id]).delete_all
      message = deleted_count.positive? ? { notice: "Job execution deleted" } : { alert: "Job execution not deleted" }
      redirect_back fallback_location: root_path, **message
    end
  end
end
