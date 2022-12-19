# frozen_string_literal: true

class BaseTspl
  FONTS = {
    'TSS16.BF2' => 16,
    'TSS20.BF2' => 20,
    'TSS24.BF2' => 24,
    'TSS32.BF2' => 32
  }

  def initialize(width: 60, height: 40)
    @width = width
    @height = height
    @texts = []
    @bars = []
    @text_height = 0
    @qrcodes = []
  end

  def render
    r = (size + @bars + @qrcodes + @texts + footer).join("\n")
    puts r
    r
  end

  def footer
    ["PRINT 1,1"]
  end

  def size
    [
      "SIZE #{@width} mm,#{@height} mm",
      "GAP 2 mm,0 mm",
      "REFERENCE 0,0",
      "CLS"
    ]
  end

  def bar(x: 0, y: 0, width: 500, height: 1)
    @bars << "BAR #{x},#{y},#{width},#{height}"
  end

  def qrcode(data, x: 20, y: 125, ecc: 'L', cell_width: 6)
    @qrcodes << "QRCODE #{x},#{y},#{ecc},#{cell_width},A,0,\"#{data}\""
  end

  # TSS16, 字体为：16x16
  def text(data, font: 'TSS24.BF2', line_height: FONTS[font] * 1.5, scale: 1, x:, y: @text_height, line_add: true)
    @texts << "TEXT #{x},#{y},\"#{font}\",0,#{scale},#{scale},\"#{data}\""
    @text_height += (line_height * scale).to_i if line_add
  end

  def middle_text(data, x:, line_add: false, **options)
    y = @height * 8 / 2
    text(data, x: x, y: y, line_add: line_add, **options)
  end

end
