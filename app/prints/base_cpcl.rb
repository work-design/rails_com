class BaseCpcl
  PADDING_TOP = 40

  # width 单位为 mm
  # 1 英寸 25.4 mm
  # 每毫米为 8点
  # 分辨率为 25.4 * 8 = 203.2 dpi
  def initialize(width: 72, height: 40)
    @width = width * 8 # 将毫米换算为 pt
    @height = height * 8 # 打印标签的最大高度点数
    @qty = 1 # 打印标签数量
    @texts = []
    @current_y = PADDING_TOP
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

  def bold_text(data, size: 1, **options)
    @texts << 'SETBOLD 2'
    @texts << "SETMAG #{size} #{size}"
    text(data, size: size, y: 36 * size, **options)
    @texts << 'SETMAG 0 0'
    @texts << 'SETBOLD 0'
  end

  # font/size 查表得 字高24， y 为行高 36 乘以 行数
  def text(data, font: 8, size: 0, x: 0, y: 36, line_add: true)
    @texts << "T #{font} #{size} #{x} #{@current_y} #{data}"
    @current_y += y if line_add
  end

  def text_center(data, font: 8, size: 0, x: 0, y: 36, line_add: true)
    @texts << "T #{font} #{size} #{x} #{@current_y} #{data}"
    @current_y += y if line_add
  end

  def text_box(font: 8, size: 0, x: 0, y: 36, line_add: true, **data)
    max_width = data.keys.map(&->(i){ i.display_width }).max
    texts = []
    data.each do |title, content|
      # 内容的宽度字符(display_width)
      content.to_s.split_by_display_width(20).each_with_index do |line, index|
        if index == 0
          texts << "T #{font} #{size} #{x + 12 * (max_width - title.display_width)} #{@current_y} \x2#{title} #{line}"
        else
          texts << "T #{font} #{size} #{x + 12 * (max_width + 2)} #{@current_y} #{line}"
        end
        @current_y += y if line_add
      end
    end
    @texts += texts
  end

  def text_bold_box_left(data, font: 8, size: 2, x: 0, y: 36, width: 28, min_line: 1, line_add: true)
    texts = []
    data.each do |content|
      # 内容的宽度字符(display_width)
      content.to_s.split_by_display_width(width).each do |line|
        texts << "T #{font} #{size} #{x} #{@current_y} #{line}"
        @current_y += y * 1.5 if line_add
      end
    end
    (min_line - texts.size).times do
      texts << "T #{font} #{size} #{x} #{@current_y} "
      @current_y += y * 1.5 if line_add
    end

    @texts += [
      'SETBOLD 2',
      "SETMAG #{size} #{size}",
      *texts,
      'SETMAG 0 0',
      'SETBOLD 0'
    ]
  end

  def text_box_left(data, font: 8, size: 0, x: 0, y: 36, width: 28, line_add: true)
    texts = []
    data.each do |content|
      # 内容的宽度字符(display_width)
      content.to_s.split_by_display_width(width).each_with_index do |line|
        texts << "T #{font} #{size} #{x} #{@current_y} #{line}"
        @current_y += y if line_add
      end
    end
    @texts += texts
  end

  #  如何计算
  def right_qrcode(data, y: 0, u: 6)
    size = RQRCode::QRCode.new(data, level: :m).qrcode.module_count
    x = @width - (u * size) - 16
    @qrcodes << [
      "B QR #{x} #{y} M 2 U #{u}",
      "MA,#{data}",
      "ENDQR"
    ].join("\n")
  end

  # todo
  def line(x0: 0, y0: 36, x1: 40 * 8, y1: 36, width: 2, line_add: true)
    @texts << "L #{x0} #{@current_y} #{x1} #{@current_y} #{width}"
    @current_y += y1 if line_add
  end

end
