# frozen_string_literal: true

module Com
  module Ext::Countable
    extend ActiveSupport::Concern

    included do
      has_many :counters, class_name: 'Com::Counter', as: :countable
    end

    def read_counter_count(extra: {})
      extras = extra.product_with_key
      all_counter = counters.where(extra: extras)

      CounterMonth.where(counter_id: all_counter.pluck(:id)).group_by(&:counter).each_with_object(0) do |(counter, counter_months), total|
        counter_months.each do |counter_month|
          total = total + counter_month.count
        end

        # 加上今天的实时数据
        today_value = today_count(counter)
        total + today_value
      end
    end

    def generate_all_counters(extra_hash: {})
      extra_hash.product_with_key.each do |extra|
        counter = counters.find_or_initialize_by(extra: extra)
        counter.save
      end
    end

  end
end