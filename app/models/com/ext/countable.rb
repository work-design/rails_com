# frozen_string_literal: true

module Com
  module Ext::Countable
    extend ActiveSupport::Concern

    included do
      has_many :counters, class_name: 'Com::Counter', as: :countable
    end

    def read_statistic_count(columns: ['really'], extra: {})
      extras = extra.product_with_key

      columns.each_with_object({}) do |column, column_h|
        all_statistic = statistics.where(column: column, extra: extras)

        StatisticMonth.where(statistic_id: all_statistic.pluck(:id)).group_by(&:statistic).each do |statistic, statistic_months|
          statistic_months.each do |statistic_month|
            column_h[statistic.column] = column_h[statistic.column].to_d + statistic_month.count.to_d
          end

          # 加上今天的实时数据
          today_value = today_count(statistic)
          column_h[statistic.column] = column_h[statistic.column].to_d + today_value.to_d
        end
      end
    end

    def generate_all_counters(extra_hash: {})
      extra_hash.product_with_key.each do |extra|
        statistic = statistics.find_or_initialize_by(column: column, extra: extra)
        statistic.save
      end
    end

  end
end