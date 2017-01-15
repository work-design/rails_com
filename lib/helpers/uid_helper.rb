module UidHelper
  extend self

  def uuid(prefix = '', time = Time.now)
    str = time.to_i.to_s + time.nsec.to_s
    str = str.to_i.to_s(36)
    str = str.upcase.scan(/.{1,4}/).join('-')
    prefix.present? ? prefix + '-' + str : str
  end

  def rand_string(len = 4)
    len.times.map { rand(65..90).chr }.join
  end

end