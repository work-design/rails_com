class BaseCpcl
  attr_accessor :lines, :texts

  # width 单位为 mm
  # 1 英寸 25.4 mm
  # 每毫米为 8点
  # 分辨率为 203.2 dpi
  def initialize(width: 72, height: 40)
    @width = width * 8 # 将毫米换算为 pt
    @height = height * 8 # 打印标签的最大高度点数
    @qty = 1 # 打印标签数量
    @texts = []
    @lines = 1
    @qrcodes = []
  end

  def render
    [
      *head,
      *@texts,
      *@qrcodes,
      'FORM',
      'PRINT',
      ''
    ].join("\n").encode!('gb2312')
  end

  def head
    [
      "! 0 200 200 #{@height} #{@qty}",
      "PW #{@width}",
      'PREFEED 64'  # 走纸，用于处理上边距
    ]
  end

  def bold_text(data, size: 0, **options)
    @texts << 'SETBOLD 2'
    @texts << "SETMAG #{size} #{size}"
    text(data, size: size, **options)
    @texts << 'SETMAG 0 0'
    @texts << 'SETBOLD 0'
  end

  # font/size 查表得 字高24， y 为行高 36 乘以 行数
  def text(data, font: 8, size: 0, x: 0, y: 36, line_add: true)
    @texts << "T #{font} #{size} #{x} #{@lines * y} #{data}"
    @lines += 1 if line_add
  end

  def text_center(data, font: 8, size: 0, x: 0, y: 36, line_add: true)
    @texts << "T #{font} #{size} #{x} #{@lines * y} #{data}"
    @lines += 1 if line_add
  end

  def text_box(font: 8, size: 0, x: 0, y: 36, line_add: true, **data)
    max_width = data.keys.map(&->(i){ i.display_width }).max
    texts = []
    data.each do |title, content|
      # 内容的宽度字符(display_width)
      content.to_s.split_by_display_width(20).each_with_index do |line, index|
        if index == 0
          texts << "T #{font} #{size} #{x + 12 * (max_width - title.display_width)} #{@lines * y} \x2#{title} #{line}"
        else
          texts << "T #{font} #{size} #{x + 12 * (max_width + 2)} #{@lines * y} #{line}"
        end
        @lines += 1 if line_add
      end
    end
    @texts += texts
  end

  def right_qrcode(data, y: 0, u: 6)
    x = @width - (u * 4.5 * 8) - 16
    @qrcodes << ["B QR #{x} #{y} M 2 U #{u}", "MA,#{data}", "ENDQR"].join("\n")
  end

  def line(x0: 0, y0: 36, x1: 40 * 8, y1: 36, width: 2, line_add: true)
    @texts << "L #{x0} #{@lines * y0} #{x1} #{@lines * y1} #{width}"
    @lines += 1 if line_add
  end

end
