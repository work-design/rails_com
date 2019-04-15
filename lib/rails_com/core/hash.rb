class Hash

  def toggle(t = true, other_hash)
    dup.toggle!(t, other_hash)
  end

  # a = {a: 1}
  # a.toggle! a: 2
  # => { a: [1, 2] }
  # a.toggle! a: 3
  # => { a: [1, 2, 3] }
  def toggle!(t = true, other_hash)
    common_keys = self.keys & other_hash.keys
    common_keys.each do |key|
      if Array(self[key]).include?(other_hash[key])
        if t
          self[key] = Array(self[key]) - Array(other_hash[key])
          if self[key].empty?
            self.delete(key)
          elsif self[key].size == 1
            self[key] = self[key][0]
          end
        end
      else
        self[key] = Array(self[key]).append(other_hash[key])
      end
    end
    other_hash.except! *common_keys
    self.merge! other_hash
    self
  end

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
