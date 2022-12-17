# frozen_string_literal: true

class BaseTspl

  def initialize(width: 60, height: 40)
    @width = width
    @height = height
    @texts = []
    @qrcodes = []
  end

  def render
    (size + @qrcodes + @texts + footer).join("\n")
  end

  def footer
    ["PRINT 1"]
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

  def text(data, x:, y:, font: 'TSS24.BF2', x_scale: 1, y_scale: 1)
    @texts << "TEXT #{x},#{y},\"#{font}\",0,#{x_scale},#{y_scale},\"#{data}\""
  end

end
