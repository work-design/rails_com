# frozen_string_literal: true
module Job::Panel
  class ExecutionsController < BaseController
    before_action :set_execution, only: [:show]
    before_action :set_job_classes, only: [:index]

    def index
      q_params = {}
      q_params.merge! 'serialized_params/job_class' => params[:job_class] if params[:job_class].present?

      @executions = GoodJob::Execution.default_where(q_params).page(params[:page])
    end

    def show
    end

    def destroy
      deleted_count = GoodJob::Execution.where(id: params[:id]).delete_all
      message = deleted_count.positive? ? { notice: "Job execution deleted" } : { alert: "Job execution not deleted" }
      redirect_back fallback_location: root_path, **message
    end

    private
    def set_execution
      @execution = GoodJob::Execution.find params[:id]
    end

    def set_job_classes
      @job_classes = GoodJob::Execution.group("serialized_params->>'job_class'").count
    end

  end
end
