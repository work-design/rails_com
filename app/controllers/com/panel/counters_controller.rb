module Com
  class Panel::CountersController < Panel::BaseController
    before_action :set_counter, only: [:show, :destroy]
    before_action :set_countable

    def index
      @counters = @countable.counters.order(created_at: :desc).page(params[:page]).per(params[:per])
    end

    def months
      @counter_counts = CounterMonth.group(:year_month).order(year_month: :desc).count(:counter_id)
    end

    def month
      q_params = {}
      q_params.merge! params.permit(:column)
      @statistics = Statistic.joins(:statistic_months).where(statistic_months: { year_month: params[:month] }).default_where(q_params).page(params[:page])
    end

    def do_cache
      @countable.statistical_month_job(params[:month])
    end

    private
    def set_counter
      @counter = Counter.find(params[:id])
    end

    def set_countable
      @countable = params[:countable_type].constantize.find params[:countable_id]
      @statistic_config = StatisticConfig.find_by(statistical_type: params[:countable_type], statistical_id: params[:countable_id])
    end

  end
end
