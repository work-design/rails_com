# frozen_string_literal: true

module Com
  module Ext::Statistical
    extend ActiveSupport::Concern

    included do
      has_many :statistics, class_name: 'Com::Statistic', as: :statistical
    end

    def statistical_month_job(year_month)
      StatisticalMonthJob.perform_later(self, year_month)
    end

    def read_statistic_all(columns: ['really'], extra: {})
      extras = extra.product_with_key

      columns.each_with_object({}) do |column, column_h|
        all_statistic = statistics.where(column: column, extra: extras)

        StatisticMonth.where(statistic_id: all_statistic.pluck(:id)).group_by(&:statistic).each do |statistic, statistic_months|
          statistic_months.each do |statistic_month|
            column_h[statistic.column] = column_h[statistic.column].to_d + statistic_month.value.to_d
          end

          # 加上今天的实时数据
          today_value = xx_today_xx(statistic)
          column_h[statistic.column] = column_h[statistic.column].to_d + today_value.to_d
        end
      end
    end

    def read_statistic_year(columns: ['really'], extra: {}, year: Date.today.year)
      extras = extra.product_with_key

      columns.each_with_object({}) do |column, column_h|
        all_statistic = statistics.where(column: column, extra: extras)

        StatisticMonth.where(statistic_id: all_statistic.pluck(:id), year: year).group_by(&:statistic).each do |statistic, statistic_months|
          statistic_months.each do |statistic_month|
            column_h[statistic_month.year_month] ||= {}
            column_h[statistic_month.year_month][statistic.column] = column_h[statistic_month.year_month][statistic.column].to_d + statistic_month.value.to_d
          end

          # 加上今天的实时数据
          today_value = xx_today_xx(statistic)
          column_h["#{Date.today.to_fs(:year_and_month)}"] ||= {}
          column_h["#{Date.today.to_fs(:year_and_month)}"][statistic.column] = column_h["#{Date.today.to_fs(:year_and_month)}"][statistic.column].to_d + today_value.to_d
        end
      end
    end

    def read_statistic_month(columns: ['really'], extra: {}, year_and_month: Date.today.to_fs(:year_and_month))
      extras = extra.product_with_key
      year, month = year_and_month.split('-')

      columns.each_with_object({}) do |column, column_h|
        all_statistic = statistics.where(column: column, extra: extras)

        StatisticMonth.where(statistic_id: all_statistic.pluck(:id), year: year, month: month).group_by(&:statistic).each do |statistic, statistic_months|
          statistic_months.each do |statistic_month|
            column_h[statistic_month.year_month] ||= {}
            column_h[statistic_month.year_month][statistic.column] = column_h[statistic_month.year_month][statistic.column].to_d + statistic_month.value.to_d
          end

          # 加上今天的实时数据
          today_value = xx_today_xx(statistic)
          column_h[year_and_month] ||= {}
          column_h[year_and_month][statistic.column] = column_h[year_and_month][statistic.column].to_d + today_value.to_d
        end
      end
    end

    def cached_statistic_year(columns: ['really', 'used', 'adjust'], start: Date.today.beginning_of_year, finish: Date.today)
      columns.each do |column|
        cached_statistic_data.each do |extra|
          statistic = statistics.find_or_initialize_by(column: column, extra: extra)
          statistic.save

          cached_statistic_month(statistic, start: start, finish: finish)
        end
      end
    end

    def cached_statistic_month(statistic, start: Date.today.beginning_of_year, finish: Date.today)
      (start.month..finish.month).each do |month|
        value = xx(statistic, 'month', start.change(month: month, day: 1))

        sm = statistic.statistic_months.find_or_initialize_by(year: start.year, month: month)
        sm.value = value
        sm.save
      end
    end

    def cached_statistic_day(statistic, today: Date.today)
      (1..(today.day - 1)).each do |day|
        value = xx(statistic, 'day', today.change(day: day))

        sd = statistic.statistic_days.find_or_initialize_by(year: today.year, month: today.month, day: day)
        sd.value = value
        sd.save
      end
    end

  end
end