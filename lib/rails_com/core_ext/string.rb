class String

  def integer?
    Integer(self).is_a?(Integer)
  rescue ArgumentError, TypeError
    false
  end

  def to_bool
    if self =~ (/(true|t|yes|y|1)$/i)
      return true
    end

    if self.blank? || self =~ (/(false|f|no|n|0)$/i)
      return false
    end

    nil
  end

end