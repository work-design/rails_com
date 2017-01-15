module UidHelper
  extend self

  def uuid(int, prefix = '', suffix = '')
    str = int.to_s(36)
    str = str + suffix
    str = str.upcase.scan(/.{1,4}/).join('-')

    if prefix.present?
      str = prefix + '-' + str
    end

    str
  end

  def nsec_uuid(prefix = '')
    time = Time.now
    str = time.to_i.to_s + time.nsec.to_s
    uuid str.to_i, prefix, rand_string
  end

  def sec_uuid(prefix = '')
    time = Time.now
    uuid time.to_i, prefix, rand_string(2)
  end

  def rand_string(len = 4)
    len.times.map { ((0..9).to_a + ('A'..'Z').to_a).sample }.join
  end

end