module Com
  class Panel::StatsController < Panel::BaseController
    before_action :set_stats, only: [:show, :destroy]

    def index
      @stats = Stats.order(created_at: :desc).page(params[:page])
    end

    private
    def set_stats
      @stats = Stats.find(params[:id])
    end

  end
end
