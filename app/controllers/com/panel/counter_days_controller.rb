module Com
  class Panel::CounterDaysController < Panel::BaseController
    before_action :set_counter

    def index
      today = Date.today
      @counter_days = @counter.counter_days.where(date: today.beginning_of_month..).order(date: :desc)
      @counter_months = @counter.counter_months.where(year: today.year, month: 1..today.month - 1).order(month: :desc)
      @counter_years = @counter.counter_years.order(year: :desc)
    end

    private
    def set_counter
      @counter = Counter.find(params[:counter_id])
    end

  end
end
