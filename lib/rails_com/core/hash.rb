class Hash

  def toggle(remove = true, other_hash)
    dup.toggle!(remove, other_hash)
  end
  
  # a = {a: 1}
  # a.toggle! a: 2
  # => { a: [1, 2] }
  # a.toggle! a: 3
  # => { a: [1, 2, 3] }
  def toggle!(remove = true, other_hash)
    
    self
  end
  
  def diff_toggle!(other_hash)
    common_keys = self.keys & other_hash.keys
    
    remove = self.slice(*common_keys).simple_diff(other_hash)
    add = other_hash.simple_diff(self.slice(*common_keys))
    
    other_hash.except! *common_keys
    add.merge! other_hash
    
    [remove, add]
  end

  # a = { a:1, b: 2 }
  # a.diff { a: [1,2] }
  # => removes: { b: 2 }
  def simple_diff(other_hash)
    basic_simple_diff(other_hash)
  end
  
  def basic_simple_diff(h = {}, other_hash)
    each do |key, value|
      v = Array(value) - Array(other_hash[key])
      if v.size > 1
        h[key] = v
      elsif v.size == 1
        h[key] = v[0]
      elsif v.empty?
        h.delete(key)
      end
    end
    
    h
  end

end
