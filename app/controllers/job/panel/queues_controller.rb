# frozen_string_literal: true
module Job
  class Panel::QueuesController < Panel::BaseController
    before_action :set_queue, only: [:pause, :resume]

    def index
      @queues = ActiveJob.queues.sort_by(&:name)
    end

    def pause
      @queue.pause
    end

    def resume
      @queue.resume
    end

    private
    def set_queue
      @queue = ActiveJob.queues[params[:id]]
    end

  end
end
