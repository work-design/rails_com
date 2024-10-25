require 'rails_com/core/date_and_time'

class Time
  include RailsCom::DateAndTime

  def self.at_milli(time)
    at time / 1000.0, (time % 1000), :millisecond
  end

end
