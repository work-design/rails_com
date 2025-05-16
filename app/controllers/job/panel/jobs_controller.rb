# frozen_string_literal: true
module Job
  class Panel::JobsController < Panel::BaseController
    before_action :set_queue
    before_action :set_common_jobs
    before_action :set_count
    before_action :set_job, only: [:show, :retry, :destroy]

    def index
      @jobs = @common_jobs.finished.page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(finished_at: :desc)
    end

    def failed
      @jobs = @common_jobs.failed.includes(:ready_execution, :claimed_execution).page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def todo
      @jobs = @common_jobs.scheduled.default_where('scheduled_at-gte': Time.current).page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(scheduled_at: :asc)
    end

    def blocked
      @jobs = @common_jobs.where.associated(:blocked_execution).page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def running
      @jobs = @common_jobs.where.associated(:claimed_execution).page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def ready
      @jobs = @common_jobs.where.associated(:ready_execution).page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(id: :desc)
    end

    def clearable
      @jobs = @common_jobs.clearable.page(params[:page]).per(params[:per])
      set_class_names
      @jobs = @jobs.order(id: :desc)
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

    def batch_destroy
      SolidQueue::Job.where(id: params[:ids].split(',')).each(&:destroy)
    end

    def batch_retry
      SolidQueue::Job.where(id: params[:ids].split(',')).each(&:retry)
    end

    def destroy
      @job.destroy
    end

    private
    def set_queue
      @queue = SolidQueue::Queue.new(params[:queue_id])
    end

    def set_common_jobs
      @common_jobs = SolidQueue::Job.default_where(q_params)
    end

    def set_count
      today_begin = SolidQueue::Job.where(created_at: ...Date.today.beginning_of_month.beginning_of_day.to_fs(:human)).order(id: :desc).first

      if today_begin
        @count = {
          index: @common_jobs.where(id: today_begin.id..).finished.async_count,
          failed: @common_jobs.where(id: today_begin.id..).failed.async_count,
          todo: @common_jobs.where(id: today_begin.id..).scheduled.where(scheduled_at: Time.current..).async_count,
          blocked: @common_jobs.where(id: today_begin.id..).where.associated(:blocked_execution).async_count,
          running: @common_jobs.where(id: today_begin.id..).where.associated(:claimed_execution).async_count,
          ready: @common_jobs.where(id: today_begin.id..).where.associated(:ready_execution).async_count,
          clearable: @common_jobs.where(id: today_begin.id..).clearable.async_count
        }
      else
        @count = {
          index: @common_jobs.finished.async_count,
          failed: @common_jobs.failed.async_count,
          todo: @common_jobs.scheduled.where(scheduled_at: Time.current..).async_count,
          blocked: @common_jobs.where.associated(:blocked_execution).async_count,
          running: @common_jobs.where.associated(:claimed_execution).async_count,
          ready: @common_jobs.where.associated(:ready_execution).async_count,
          clearable: @common_jobs.clearable.async_count
        }
      end
    end

    def set_job
      @job = SolidQueue::Job.find params[:id]
    end

    def set_class_names
      @class_names = @jobs.select(:class_name).group(:class_name).count
    end

    def q_params
      q = { queue_name: params[:queue_id] }
      q.merge! params.permit(:class_name, 'finished_at-desc')
      q
    end

  end
end
