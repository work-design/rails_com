module RegexpUtil
  extend self

  # + one or more times
  # * zero or more times
  # greedy: 贪婪模式，尽可能多次的匹配
  # non greedy：非贪婪模式，尽可能少的
  def between(prefix, suffix, quantifier: '*', greedy: false)
    /(?<=#{prefix}).#{quantifier}#{greedy ? '' : '?'}(?=#{suffix})/
  end

  def least_between(prefix, suffix)
    between(prefix, suffix, quantifier: '+', greedy: false)
  end

  def more_between(prefix, suffix)
    between(prefix, suffix, quantifier: '*', greedy: true)
  end

  def rails_log()
    {
      method: ['Started ', ' '],
      path: [' "', '" ']
    }
  end

  def xx(**options)
    options.map do |key, value|
      "#{value[0]}(?<#{key}>[^#{value[1]}]*)"
    end



    /^ #{} $/
  end

  def china_mobile?(tel)
    tel.to_s.match? /^1(3[0-9]|4[01456879]|5[0-35-9]|6[2567]|7[0-8]|8[0-9]|9[0-35-9])\d{8}$/
  end

end
