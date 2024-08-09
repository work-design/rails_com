# frozen_string_literal: true
module SolidQueue
  class Panel::ProcessesController < Panel::BaseController

    def index
      @processes = SolidQueue::Process.order(created_at: :desc)
    end

  end
end
