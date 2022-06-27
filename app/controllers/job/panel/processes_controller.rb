# frozen_string_literal: true
module Job::Panel
  class ProcessesController < BaseController

    def index
      @processes = GoodJob::Process.active.order(created_at: :desc)
    end

  end
end
