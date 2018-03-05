module TimeHelper
  extend self
  
  # todo consider timezone
  def exact_distance_time(from_time, to_time)
    from_time = from_time.to_datetime
    to_time = to_time.to_datetime

    return nil if from_time > to_time

    years = to_time.year - from_time.year
    months = to_time.month - from_time.month
    days = to_time.mday - from_time.mday
    day_seconds = to_time.seconds_since_midnight.to_i - from_time.seconds_since_midnight.to_i
    
    if [months, days, day_seconds].find { |i| i < 0 }
      years -= 1
    end

    if months < 0
      months = 12 + months
    end

    if days < 0
      months -= 1
    end

    if days < 0
      days = to_time.prev_month.end_of_month.mday + days
    end

    if day_seconds < 0
      days -= 1
    end

    if day_seconds < 0
      day_seconds = 86400 + day_seconds
    end

    hours, minute_seconds = day_seconds.to_i.divmod(3600)
    minutes, seconds = minute_seconds.divmod(60)

    { year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds }
  end

end

