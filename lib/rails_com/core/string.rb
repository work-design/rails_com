class String

  def integer?
    Integer(self).is_a?(Integer)
  rescue ArgumentError, TypeError
    false
  end

  def numeric?
    Float(self).is_a?(Numeric)
  rescue ArgumentError, TypeError
    false
  end

  def to_controller
    r = camelize
    if r.end_with?('Controller')
      r.safe_constantize
    else
      "#{r}Controller".safe_constantize
    end
  end

  def start_with_same(another)
    _chars = another.chars_step
    _chars.each_with_index do |i, index|
      break index >= 1 ? _chars[index - 1] : '' unless start_with?(i)
    end
  end

  # '12345'
  # '1', '12', '123', '1234'
  def chars_step
    chars.ancestors('')
  end

end
