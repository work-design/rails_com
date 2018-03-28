class Setting < OpenStruct

  def initialize(hash = {})
    @table = {}
    @hash_table = {}

    hash.each do |k, v|
      @table[k.to_sym] = v.is_a?(Hash) ? self.class.new(v) : v
      @hash_table[k.to_sym] = v

      new_ostruct_member(k)
    end
  end

  def to_hash
    @hash_table.with_indifferent_access
  end

end

class Settings < Array

  def initialize(data = [])
    data.map do |h|
      self << Setting.new(h)
    end
  end

end