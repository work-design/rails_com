require 'rails_extend/core/date_and_time'

class DateTime
  include RailsExtend::DateAndTime

  def inspect
    to_s
  end

end
