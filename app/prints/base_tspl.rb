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
    @lines = 0
    @qrcodes = []
  end

  def render
    r = (size + @qrcodes + @texts + footer).join("\n")
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

  def qrcode(data, x: 20, y: 125, ecc: 'L', cell_width: 6)
    @qrcodes << "QRCODE #{x},#{y},#{ecc},#{cell_width},A,0,\"#{data}\""
  end

  # TSS16, 字体为：16x16
  def text(data, font: 'TSS24.BF2', line_height: FONTS[font] * 1.5, scale: 1, x:, y: @lines * line_height * scale, line_add: true)
    @texts << "TEXT #{x},#{y},\"#{font}\",0,#{scale},#{scale},\"#{data}\""
    @lines += 1 if line_add
  end

end
