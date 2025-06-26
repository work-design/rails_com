module Statis
  module Model::Config
    extend ActiveSupport::Concern

    included do
      attribute :statistical_type, :string
      attribute :begin_on, :date
      attribute :end_on, :date
      attribute :note, :string
      attribute :scopes, :json, default: []
      attribute :keys, :json, default: []
      attribute :sums, :json, default: []
      attribute :today, :date
      attribute :today_begin_id, :big_integer
      attribute :counter_years_count, :integer
      attribute :counter_months_count, :integer
      attribute :counter_days_count, :integer

      has_many :counter_days
      has_many :counter_months
      has_many :counter_years
    end

    def compute_today_begin!
      id = countable.where(created_at: ...Date.today.beginning_of_day.to_fs(:human)).order(id: :desc).first.id
      self.today_begin_id = id
      self.today = Date.today
      self.save
    end

    def keys_gen

    end

    def countable
      statistical_type.constantize
    end

    def cache_from_config
      #self.update cached: true
    end

    def cache_counter_months(start: begin_on, finish: end_on)
      first_day = start.beginning_of_month
      if start > first_day
        cache_counter_days(start: start, finish: start.end_of_month)
      end

      next_last_day = start.next_month.end_of_month
      while next_last_day < finish
        cache_counter_month(next_last_day.to_fs(:year_and_month))
        next_last_day = next_last_day.next_month.end_of_month
      end

      if finish.end_of_month == finish
        cache_counter_month(finish.to_fs(:year_and_month))
      else
        cache_counter_days(start: finish.beginning_of_month, finish: finish)
      end
    end

    def cache_counter_year(year)
      the_day = Date.new(year, 1, 1)
      time_range = the_day.beginning_of_day ... (the_day.end_of_year + 1).beginning_of_day
      arr = countable.where(created_at: time_range).select(scopes).distinct.pluck(scopes)

      arr.each do |k|
        counter_year = counter_years.build(year: year)
        counter_year.filter = scopes.zip(k).to_h
        counter_year.cache_value
        counter_year.save
      end
    end

    def cache_counter_month(year, month)
      the_day = Date.new(year, month, 1)
      time_range  = the_day.beginning_of_day ... (the_day.end_of_month + 1).beginning_of_day
      arr = countable.where(created_at: time_range).select(scopes).distinct.pluck(scopes)

      arr.each do |k|
        counter_month = counter_months.build(year: year, month: month)
        counter_month.filter = scopes.zip(k).to_h
        counter_month.cache_value
        counter_month.save
      end
    end

    def cache_counter_day(date = begin_on)
      time_range  = date.beginning_of_day ... (date + 1).beginning_of_day
      arr = countable.where(created_at: time_range).select(scopes).distinct.pluck(scopes)

      counter_days.where(date: date).delete_all
      arr.each do |k|
        counter_day = counter_days.build(date: date)
        counter_day.filter = scopes.zip(k).to_h
        counter_day.cache_value
        counter_day.save
      end

    end

  end
end
