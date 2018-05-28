module NumHelper
  NUM = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖']
  DEL = ['', '拾', '佰', '仟']
  UNIT = ['', '万', '亿', '兆', '京']
  SUB_UNIT = ['角', '分']
  DELIMITER_REGEX = /(\d)(?=(\d\d\d\d)+(?!\d))/
  extend self

  def to_rmb(num, unit: '元')
    left, right = num.to_s(:rounded, precision: 2, strip_insignificant_zeros: true, separator: '.', delimiter: ',', delimiter_pattern: DELIMITER_REGEX).split('.')

    left_str = xxx(left, unit: UNIT)
    right_str = xxx(right, unit: SUB_UNIT)

    if right
      left_str + right_str
    else
      left_str + '整'
    end
  end

  def xxx(arr, unit: [])
    han_arr = arr.split(',').reverse.map.with_index do |str, index|
      str = str.each_char.map { |i| NUM[i.to_i] }
      xx = ''
      str.zip(DEL[0..str.size - 1].reverse) do |st, de|
        if st != '零'
          xx << st + de
        else
          xx << st unless xx.end_with?('零')
        end
      end
      if xx.chomp!('零')
        xx << (unit[index]) << '零'
      else
        xx << (unit[index])
      end
      xx
    end
    han_arr.reverse.join + unit.to_s
  end

end

