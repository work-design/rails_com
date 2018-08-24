class Date

  # '2018-01-01'.to_date.after(2.month) => '2018-02-31'
  # '2018-01-31'.to_date.after(1.month) => '2018-03-02'
  def after(other)
    if ActiveSupport::Duration === other
      if other.parts.keys == [:months]
        date = self + other
        if date.day == self.day
          r = date - 1.day
        else
          r = date + (self.day - date.day - 1).days
        end

        r
      else
        self + other
      end
    else
      self + other
    end
  end

end