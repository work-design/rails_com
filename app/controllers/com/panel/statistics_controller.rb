module Com
  class Panel::StatisticsController < Panel::BaseController
    before_action :set_statistic, only: [:show, :destroy]

    def index
      @statistics = Statistic.order(created_at: :desc).page(params[:page]).per(params[:per])
    end

    def months
      @months = StatisticMonth.months
    end

    private
    def set_statistic
      @statistic = Statistic.find(params[:id])
    end

  end
end
