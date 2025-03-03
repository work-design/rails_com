module Com
  class StatisticalYearJob < ApplicationJob

    def perform(statistical, month)
      month = Date.new(*params[:month].split('-').map(&:to_i))
      statistical.cached_statistic_year(start: month, finish: month.end_of_month)
    end

  end
end
