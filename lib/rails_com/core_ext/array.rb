class Array

  def rjust!(n, x)
    return self if n < length
    insert(0, *Array.new([0, n-length].max, x))
  end

  def ljust!(n, x)
    return self if n < length
    fill(x, length...n)
  end

  # arr = [1, 2, 3]
  # arr.mjust!(5, nil)
  # => [1, 2, nil, nil, 3]
  def mjust!(n, x)
    return self if n < length
    insert (length / 2.0).ceil, *Array.new(n - length, x)
  end

  # raw_data = [
  #   { a: 1 },
  #   { a: 2 },
  #   { b: 2 }
  # ]
  def to_combined_hash
    self.reduce({}) do |memo, index|
      memo.merge(index) { |_, value, default| [value, default] }
    end
  end

  # see ruby cook book
  # raw_data = [
  #   [:a, 1],
  #   [:a, 2],
  #   [:b, 2]
  # ]
  def to_combined_h
    hash = Hash.new { |hash, key| hash[key] = [] }
    self.each { |x, y| hash[x] << y }
    hash
  end

end