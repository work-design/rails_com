class Date

  # Chinese custom after date
  #   '2018-01-01'.to_date.after(2.month) => '2018-02-31'
  #   '2018-01-31'.to_date.after(1.month) => '2018-03-02'
  def contract_duration(*afters)
    parts = {}
    # todo use inject or something
    afters.each do |after|
      parts.merge! after.parts
    end
    ActiveSupport::Duration.new(0, parts).after(self)
  end

  def parts
    {
      year: year,
      month: month,
      day: day
    }
  end

end
