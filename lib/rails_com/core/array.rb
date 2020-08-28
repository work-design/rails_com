# frozen_string_literal: true

class Array
  #   arr = [1, 2, 3]
  #   arr.ljust! 5, nil
  #   # => [nil, nil, 1, 2, 3]
  def ljust!(integer, padstr)
    return self if integer < length

    insert(0, *Array.new([0, integer - length].max, padstr))
  end

  # fill an array with the given elements left;
  #   arr = [1, 2, 3]
  #   arr.rjust! 5, nil
  #   # => [1, 2, 3, nil, nil]
  def rjust!(integer, padstr)
    return self if integer < length

    fill(padstr, length...integer)
  end

  ##
  #   arr = [1, 2, 3]
  #   arr.mjust!(5, nil)
  #   # => [1, 2, nil, nil, 3]
  def mjust!(integer, padstr)
    return self if integer < length

    insert((length / 2.0).ceil, *Array.new(integer - length, padstr))
  end

  ##
  # combine the same key hash like array
  #   raw_data = [
  #     { a: 1 },
  #     { a: 2 },
  #     { b: 2 },
  #     { b: 2 }
  #   ]
  #   raw_data.to_combine_h
  #   #=> { a: [1, 2], b: 2 }
  def to_combine_h
    inject({}) do |memo, obj|
      memo.merge(obj) do |_, old_val, new_val|
        v = (Array(old_val) + Array(new_val)).uniq
        v.size > 1 ? v : v[0]
      end
    end
  end

  #
  # raw_data = [
  #   [:a, 1],
  #   [:a, 2, 3],
  #   [:b, 2]
  # ]
  # raw_data.to_array_h
  # #=> [ { a: 1 }, { a: 2 }, { b: 2 } ]
  def to_array_h
    map { |x, y| { x => y } }
  end

  # 2D array to csv file
  #   data = [
  #     [1, 2],
  #     [3, 4]
  #   ]
  #   data.to_csv_file
  def to_csv_file(file = 'export.csv')
    CSV.open(file, 'w') do |csv|
      each { |ar| csv << ar }
    end
  end
end
