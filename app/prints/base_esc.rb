class BaseEsc
  attr_reader :data

  def initialize
    @data = []
    @data.concat(Escpos::HW_INIT)
    @data.concat(Escpos::HW_PAGE)
    @data.concat([0x1d, 0x4c, 0x02, 0x00])
  end

  def partial_cut!
    @data.concat(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut!
    @data.concat(Escpos::PAPER_FULL_CUT)
  end

  def render
    @data.concat(Escpos::CTL_LF)
    #cut!
    @data.bytes.map {|i| i.to_s(16) }.join('')
  end

  # Encodes UTF-8 string to encoding acceptable for the printer
  # The printer must be set to that encoding
  # Available encodings can be listed in console using Encoding.constants
  def encode(data, opts = {})
    data.encode(opts.fetch(:encoding), 'UTF-8', {
      invalid: opts.fetch(:invalid, :replace),
      undef: opts.fetch(:undef, :replace),
      replace: opts.fetch(:replace, '?')
    })
  end

  # Set printer encoding
  # example: encoding(Escpos::CP_ISO8859_2)
  def encoding(data)
    [
      sequence(Escpos::CP_SET),
      sequence(data)
    ].join
  end

  def text(data)
    @data.concat *[Escpos::TXT_NORMAL, data.bytes, Escpos::TXT_NORMAL, Escpos::CTL_LF]
  end

  def double_height(data)
    @data.concat *[Escpos::TXT_2HEIGHT, data.bytes, Escpos::TXT_NORMAL]
  end

  def quad_text(data)
    @data.concat *[Escpos::TXT_4SQUARE, data.bytes, Escpos::TXT_NORMAL, Escpos::CTL_LF]
  end

  def double_width(data)
    @data.concat *[Escpos::TXT_2WIDTH, data.bytes, Escpos::TXT_NORMAL]
  end

  def underline(data)
    @data.concat *[Escpos::TXT_UNDERL_ON, data.bytes, Escpos::TXT_UNDERL_OFF]
  end

  def underline2(data)
    @data.concat *[Escpos::TXT_UNDERL2_ON, data.bytes, Escpos::TXT_UNDERL_OFF]
  end

  def bold(data)
    @data.concat *[Escpos::TXT_BOLD_ON, data.bytes, Escpos::TXT_BOLD_OFF]
  end

  def left(data = '')
    @data.concat *[Escpos::TXT_ALIGN_LT, data.bytes, Escpos::TXT_ALIGN_LT]
  end

  def right(data = '')
    @data << [
      sequence(Escpos::TXT_ALIGN_RT),
      data,
      sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def center(data = '')
    @data << [
      sequence(Escpos::TXT_ALIGN_CT),
      data,
      sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def inverted(data)
    @data << [
      sequence(Escpos::TXT_INVERT_ON),
      data,
      sequence(Escpos::TXT_INVERT_OFF),
    ].join
  end

  def black
    @data << [
      sequence(Escpos::TXT_COLOR_BLACK),
      data,
      sequence(Escpos::TXT_COLOR_BLACK),
    ].join
  end

  def red
    @data.concat *[
      Escpos::TXT_COLOR_BLACK,
      data.bytes,
      Escpos::TXT_COLOR_RED
    ]
  end

  def barcode(data, opts = {})
    text_position = opts.fetch(:text_position, Escpos::BARCODE_TXT_OFF)
    possible_text_positions = [
      Escpos::BARCODE_TXT_OFF,
      Escpos::BARCODE_TXT_ABV,
      Escpos::BARCODE_TXT_BLW,
      Escpos::BARCODE_TXT_BTH
    ]
    unless possible_text_positions.include?(text_position)
      raise ArgumentError("Wrong text position.")
    end
    height = opts.fetch(:height, 50)
    if height && (height < 1 || height > 255)
      raise ArgumentError("Height must be in range from 1 to 255.")
    end
    width = opts.fetch(:width, 3)
    if width && (width < 2 || width > 6)
      raise ArgumentError("Width must be in range from 2 to 6.")
    end

    @data.concat *[
      text_position,
      Escpos::BARCODE_WIDTH,
      [width],
      Escpos::BARCODE_HEIGHT,
      [height],
      opts.fetch(:format, Escpos::BARCODE_EAN13),
      data.bytes
    ]
  end

  def partial_cut
    @data.concat(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut
    @data.concat(Escpos::PAPER_FULL_CUT)
  end

  # Transforms an array of codes into a string
  def sequence(*arr_sequence)
    arr_sequence.flatten.pack('U*')
  end

end
