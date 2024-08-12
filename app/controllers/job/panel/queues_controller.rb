# frozen_string_literal: true
module Job
  class Panel::QueuesController < Panel::BaseController

    def index
      @queues = ActiveJob.queues.sort_by(&:name)
    end

  end
end
