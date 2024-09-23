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
    @lines = 0
    @qrcodes = []
  end

  def render
    (head + @texts + @qrcodes + ['FORM'] + ['PRINT', '']).join("\n").encode!('gb2312')
  end

  def head
    [
      "! 0 200 200 #{@height} #{@qty}",
      "PW #{@width}",
      'PREFEED 64'  # 走纸，用于处理上边距
    ]
  end

  def bold_text(data, **options)
    @texts << 'SETBOLD 2'
    text(data, **options)
    @texts << 'SETBOLD 0'
  end

  # font/size 查表得 字高24， y 为行高 36 乘以 行数
  def text(data, font: 8, size: 0, x: 0, y: 36, line_add: true)
    @texts << "T #{font} #{size} #{x} #{@lines * y} #{data}"
    @lines += 1 if line_add
  end

  def right_qrcode(data, y: 0, u: 6)
    x = @width - (u * 4.5 * 8)
    @qrcodes << ["B QR #{x} #{y} M 2 U #{u}", "MA,#{data}", "ENDQR"].join("\n")
  end

  def line(x0: 0, y0: 36, x1: 40 * 8, y1: 36, width: 2, line_add: true)
    @texts << "L #{x0} #{@lines * y0} #{x1} #{@lines * y1} #{width}"
    @lines += 1 if line_add
  end

end
