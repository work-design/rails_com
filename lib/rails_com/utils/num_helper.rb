module NumHelper
  NUM = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'].freeze
  DEL = [nil, '拾', '佰', '仟'].freeze
  SUB_DEL = ['分', '角'].freeze
  UNIT = ['元', '万', '亿', '兆', '京'].freeze
  DELIMITER_REGEX = /(\d)(?=(\d\d\d\d)+(?!\d))/.freeze
  extend self

  def to_rmb(num)
    left, right = num.to_fs(
      :rounded,
      precision: 2,
      strip_insignificant_zeros: true,
      separator: '.',
      delimiter: ',',
      delimiter_pattern: DELIMITER_REGEX
    ).split('.')
    left_str = to_parts(left, unit: UNIT, del: DEL)

    if right
      right_str = to_parts(right, unit: [], del: SUB_DEL)
      left_str + right_str
    else
      left_str.chomp('零') + '整'
    end
  end

  def to_parts(num_str, unit: UNIT, del: DEL)
    #raise '数字位数不匹配' if del.size < num_str.size
    han_arr = num_str.to_s.split(',').reverse.map.with_index do |str, index|
      del = del[0..str.size - 1].reverse
      str_arr = str.each_char.map.with_index { |i, position| "#{NUM[i.to_i]}#{del[position]}" }

      Rails.logger.debug "str: #{str_arr}"

      xx = str_arr.join.gsub /(零[拾佰仟]|零)+/, '零'
      xx.chomp!('零')
      xx << (unit[index].to_s)
    end

    han_arr.reverse.join
  end

end

