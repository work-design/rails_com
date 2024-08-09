# frozen_string_literal: true
module SolidQueue
  class Panel::JobsController < Panel::BaseController
    before_action :set_job, only: [:show, :perform]
    before_action :set_job_classes, only: [:index, :scheduled, :running, :discarded]

    def index
      @jobs = Job.default_where(q_params).order(id: :desc).page(params[:page])
    end

    def scheduled
      @jobs = Job.scheduled.default_where(q_params).order(scheduled_at: :desc).page(params[:page])
    end

    def running
      @jobs = Job.finished.default_where(q_params).order(scheduled_at: :desc).page(params[:page])
    end

    def discarded
      @jobs = Job.clearable.default_where(q_params).page(params[:page])
    end

    def show
    end

    def perform
      @execution.perform
    end

    def destroy
      deleted_count = GoodJob::Execution.where(id: params[:id]).delete_all
      message = deleted_count.positive? ? { notice: "Job execution deleted" } : { alert: "Job execution not deleted" }
      redirect_back fallback_location: root_path, **message
    end

    private
    def q_params
      q = {}
      q.merge! 'serialized_params/job_class' => params[:job_class] if params[:job_class].present?
    end

    def set_job
      @job = Job.find params[:id]
    end

    def set_job_classes
      @job_classes = Job.select(:class_name).distinct.pluck(:class_name)
    end

  end
end
