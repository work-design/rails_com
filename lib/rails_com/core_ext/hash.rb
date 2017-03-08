class Hash

  def deep_transform_values(&block)
    _deep_transform_values_in_object(self, &block)
  end

  def deep_transform_values!(&block)
    _deep_transform_values_in_object!(self, &block)
  end

  private
  def _deep_transform_values_in_object(object, &block)
    case object
    when Hash
      object.each_with_object({}) do |(key, value), result|
        result[key] = _deep_transform_values_in_object(value, &block)
      end
    when Array
      object.map { |e| _deep_transform_values_in_object(e, &block) }
    else
      yield(object)
    end
  end

  def _deep_transform_values_in_object!(object, &block)
    case object
    when Hash
      object.each do |key, value|
        object[key] = _deep_transform_values_in_object!(value, &block)
      end
    when Array
      object.map! { |e| _deep_transform_values_in_object!(e, &block) }
    else
      yield(object)
    end
  end

end