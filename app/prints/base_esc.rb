class BaseEsc
  attr_reader :data

  def initialize
    # ensure only supported sequences are generated
    @data = ''.force_encoding('ASCII-8BIT')
    @data << sequence(Escpos::HW_INIT)
  end

  def write(data)
    @data << data.force_encoding('ASCII-8BIT')
  end

  def partial_cut!
    @data << sequence(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut!
    @data << sequence(Escpos::PAPER_FULL_CUT)
  end

  def render
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
    [
      sequence(Escpos::TXT_NORMAL),
      data,
      sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def double_height(data)
    [
      sequence(Escpos::TXT_2HEIGHT),
      data,
      sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def quad_text(data)
    [
      sequence(Escpos::TXT_4SQUARE),
      data,
      sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def double_width(data)
    [
      sequence(Escpos::TXT_2WIDTH),
      data,
      sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def underline(data)
    [
      sequence(Escpos::TXT_UNDERL_ON),
      data,
      sequence(Escpos::TXT_UNDERL_OFF),
    ].join
  end

  def underline2(data)
    [
      sequence(Escpos::TXT_UNDERL2_ON),
      data,
      sequence(Escpos::TXT_UNDERL_OFF),
    ].join
  end

  def bold(data)
    [
      sequence(Escpos::TXT_BOLD_ON),
      data,
      sequence(Escpos::TXT_BOLD_OFF),
    ].join
  end

  def left(data = '')
    [
      sequence(Escpos::TXT_ALIGN_LT),
      data,
      sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def right(data = '')
    [
      sequence(Escpos::TXT_ALIGN_RT),
      data,
      sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def center(data = '')
    [
      sequence(Escpos::TXT_ALIGN_CT),
      data,
      sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def inverted(data)
    [
      sequence(Escpos::TXT_INVERT_ON),
      data,
      sequence(Escpos::TXT_INVERT_OFF),
    ].join
  end

  def black
    [
      sequence(Escpos::TXT_COLOR_BLACK),
      data,
      sequence(Escpos::TXT_COLOR_BLACK),
    ].join
  end

  def red
    [
      sequence(Escpos::TXT_COLOR_BLACK),
      data,
      sequence(Escpos::TXT_COLOR_RED),
    ].join
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
    [
      sequence(text_position),
      sequence(Escpos::BARCODE_WIDTH),
      sequence([width]),
      sequence(Escpos::BARCODE_HEIGHT),
      sequence([height]),
      sequence(opts.fetch(:format, Escpos::BARCODE_EAN13)),
      data
    ].join
  end

  def partial_cut
    sequence(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut
    sequence(Escpos::PAPER_FULL_CUT)
  end

  # Transforms an array of codes into a string
  def sequence(*arr_sequence)
    arr_sequence.flatten.pack('U*')
  end

end
