require 'rails_extend/core/date_and_time'

module ActiveSupport
  class TimeWithZone
    include RailsCom::DateAndTime

    def inspect
      to_fs
    end

  end
end
