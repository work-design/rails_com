require 'rails_extend/core/date_and_time'

class DateTime
  include RailsCom::DateAndTime

  def inspect
    to_s
  end

end
