module NumHelper
  NUM = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'].freeze
  DEL = ['', '拾', '佰', '仟'].freeze
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
    han_arr = num_str.to_s.split(',').reverse.map.with_index do |str, index|
      str = str.each_char.map { |i| NUM[i.to_i] }
      xx = ''
      str.zip(del[0..str.size - 1].reverse) do |st, de|
        if st != '零' && de
          xx << st + de
        else
          xx << st unless xx.end_with?('零')
        end
      end

      xx << (unit[index].to_s)
    end

    han_arr.reverse.join
  end

end

