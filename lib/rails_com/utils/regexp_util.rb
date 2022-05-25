module RegexpUtil
  extend self

  def between(prefix, suffix)
    /(?<=#{prefix}).*?(?=#{suffix})/
  end

  def more_between(prefix, suffix)
    /(?<=#{prefix}).*(?=#{suffix})/
  end

end
