module Com
  class Panel::StatisticsController < Panel::BaseController
    before_action :set_statistic, only: [:show, :destroy]
    before_action :set_statistical, only: [:do_cache]

    def index
      @statistics = Statistic.order(created_at: :desc).page(params[:page]).per(params[:per])
    end

    def statistical
      @statistics = Statistic.select(:statistical_type, :statistical_id).distinct.page(params[:page])
    end

    def months
      @month_counts = StatisticMonth.group(:year_month).order(year_month: :desc).count(:statistic_id)
    end

    def month
      @statistics = Statistic.joins(:statistic_months).where(statistic_months: { year_month: params[:month] }).page(params[:page])
    end

    def do_cache
      month = Date.new(*params[:month].split('-').map(&:to_i))

      @statistical.cached_statistic_year(start: month, finish: month.end_of_month)
    end

    private
    def set_statistic
      @statistic = Statistic.find(params[:id])
    end

    def set_statistical
      @statistical = params[:statistical_type].constantize.find params[:statistical_id]
    end

  end
end
