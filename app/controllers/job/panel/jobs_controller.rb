# frozen_string_literal: true
module Job
  class Panel::JobsController < Panel::BaseController
    before_action :set_queue
    before_action :set_job, only: [:show, :retry, :destroy]

    def index
      @jobs = SolidQueue::Job.finished.default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def failed
      @jobs = SolidQueue::Job.failed.default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def scheduled
      @jobs = SolidQueue::Job.scheduled.default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(scheduled_at: :desc)
    end

    def blocked
      @jobs = SolidQueue::Job.where.associated(:blocked_execution).default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def running
      @jobs = SolidQueue::Job.where.associated(:claimed_execution).default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def ready
      @jobs = SolidQueue::Job.where.associated(:ready_execution).default_where(q_params).page(params[:page])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def clearable
      @jobs = SolidQueue::Job.clearable.default_where(q_params).page(params[:page])
      set_class_names
    end

    def clear_all
      SolidQueue::Job.clear_finished_in_batches(class_name: params[:class_name])
    end

    def retry
      @job.retry
    end

    def retry_all
      jobs = SolidQueue::Job.failed.default_where(q_params)
      SolidQueue::FailedExecution.retry_all(jobs)
    end

    def destroy
      @job.destroy
    end

    private
    def set_queue
      queues_hash = SolidQueue::Queue.all.each_with_object({}) do |queue, h|
        h.merge! queue.name => queue
      end
      @queue = queues_hash[params[:queue_id]]
    end

    def set_job
      @job = SolidQueue::Job.find params[:id]
    end

    def set_class_names
      @class_names = @jobs.select(:class_name).group(:class_name).count
    end

    def q_params
      q = { queue_name: params[:queue_id] }
      q.merge! params.permit(:class_name)
      q
    end

  end
end
