# frozen_string_literal: true

module TimeHelper
  extend self

  def exact_distance_time(from_time = 0, to_time)
    if to_time.is_a?(Numeric)
      from_time = Time.at(from_time)
      to_time = Time.at(to_time)
    else
      from_time = from_time.to_datetime
      to_time = to_time.to_datetime
    end

    return {} if from_time > to_time

    years = to_time.year - from_time.year
    months = to_time.month - from_time.month
    days = to_time.mday - from_time.mday
    day_seconds = to_time.seconds_since_midnight.to_i - from_time.seconds_since_midnight.to_i

    if day_seconds < 0
      days -= 1
      day_seconds = 86_400 + day_seconds
    end

    if days < 0
      months -= 1
      days = to_time.prev_month.end_of_month.mday + days
    end

    if months < 0
      years -= 1
      months = 12 + months
    end

    hours, minute_seconds = day_seconds.to_i.divmod(3600)
    minutes, seconds = minute_seconds.divmod(60)

    { year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds }
  end

  def interval(start_at, finish_at, interval_start: '12:30', since: 1.hour)
    return 0 if start_at.blank? || finish_at.blank? || start_at >= finish_at
    raise 'Must be same day!' if start_at.to_date != finish_at.to_date

    hour, min = interval_start.split(':')
    interval_start_at = start_at.change hour: hour, min: min
    interval_finish_at = interval_start_at.since(since)

    seconds = if start_at < interval_start_at && finish_at > interval_finish_at
                ((finish_at - start_at) - since).to_i
              elsif start_at < interval_start_at && finish_at >= interval_start_at && finish_at <= interval_finish_at
                interval_start_at - start_at
              elsif start_at >= interval_start_at && start_at <= interval_finish_at && finish_at > interval_finish_at
                finish_at - interval_finish_at
              elsif start_at >= interval_start_at && start_at <= interval_finish_at && finish_at <= interval_finish_at
                0
              else
                finish_at - start_at
              end
    seconds
  end
end
