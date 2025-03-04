module Com
  class Panel::StatisticMonthsController < Panel::BaseController
    before_action :set_statistic

    def index
      @statistic_months = @statistic.statistic_months.order(year_month: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_statistic
      @statistic = Statistic.find(params[:statistic_id])
    end

  end
end
