# frozen_string_literal: true
module Job
  class Panel::ProcessesController < Panel::BaseController

    def index
      @processes = SolidQueue::Process.where(supervisor_id: nil).order(created_at: :desc)
    end

  end
end
