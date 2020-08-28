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
    common_keys = keys & other_hash.keys
    common_keys.each do |key|
      removed = if remove
                  Array(self[key]) & Array(other_hash[key])
                else
                  []
                end
      added = Array(other_hash[key]) - Array(self[key])
      self[key] = Array(self[key]) - removed + added
      if self[key].empty?
        delete(key)
      elsif self[key].size == 1
        self[key] = self[key][0]
      end
    end
    other_hash.except!(*common_keys)
    merge! other_hash
    self
  end

  def diff_toggle(remove = true, other_hash)
    removed = {}
    added = {}
    o = other_hash.extract!(*(keys & other_hash.keys))

    removed.merge! o.common_basic(self) if remove
    added.merge! o.diff_basic(self)
    added.merge! other_hash

    [removed, added]
  end

  # a = { a:1, b: 2 }
  # a.diff_remove { a: [1,2] }
  # => removes: { b: 2 }
  def diff_remove(other_hash)
    diff_basic(other_hash)
  end

  # a = { a:1, b: 2 }
  # a.diff_add { a: [1,2] }
  # => adds: { b: 2 }
  def diff_add(other_hash)
    other_hash.diff_basic(self)
  end

  def diff_changes(other_hash)
    [diff_remove(other_hash), diff_add(other_hash)]
  end

  def diff_basic(target_hash = {}, other_hash)
    each do |key, value|
      v = Array(value) - Array(other_hash[key])
      if v.size > 1
        target_hash[key] = v
      elsif v.size == 1
        target_hash[key] = v[0]
      elsif v.empty?
        target_hash.delete(key)
      end
    end
    target_hash
  end

  def common_basic(target_hash = {}, other_hash)
    each do |key, value|
      v = Array(value) & Array(other_hash[key])
      if v.size > 1
        target_hash[key] = v
      elsif v.size == 1
        target_hash[key] = v[0]
      elsif v.empty?
        target_hash.delete(key)
      end
    end
    target_hash
  end
end
