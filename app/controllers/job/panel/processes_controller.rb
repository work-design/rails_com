# frozen_string_literal: true
module Job::Panel
  class ProcessesController < BaseController

    def index
      if GoodJob::Process.migrated?
        @processes = GoodJob::Process.active.order(created_at: :desc)
      else
        @processes = GoodJob::Process.none
      end
    end

  end
end
