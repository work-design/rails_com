module RegexpUtil
  extend self

  def between(prefix, suffix)
    /(?<=#{prefix}).*?(?=#{suffix})/
  end

  def more_between(prefix, suffix)
    /(?<=#{prefix}).*(?=#{suffix})/
  end

  def china_mobile?(tel)
    tel.to_s.match? /^1(3[0-9]|4[01456879]|5[0-35-9]|6[2567]|7[0-8]|8[0-9]|9[0-35-9])\d{8}$/
  end

end
