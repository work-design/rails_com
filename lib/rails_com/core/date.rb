class Date

  # Chinese custom after date
  #   '2018-01-01'.to_date.contract_after(2.month) => '2018-02-31'
  #   '2018-01-31'.to_date.contract_after(1.month) => '2018-02-28'
  def contract_after(*afters, less: false)
    parts = {}
    # todo use inject or something
    afters.each do |after|
      parts.merge! after.parts
    end
    date = ActiveSupport::Duration.new(0, parts).after(self)

    return date unless less

    day <= date.day ? date - 1 : date
  end

  def parts
    {
      year: year,
      month: month,
      day: day
    }
  end

end
