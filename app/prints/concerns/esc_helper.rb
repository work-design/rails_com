module EscHelper
  extend self

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
      Escpos.sequence(Escpos::CP_SET),
      Escpos.sequence(data)
    ].join
  end

  def text(data)
    [
      Escpos.sequence(Escpos::TXT_NORMAL),
      data,
      Escpos.sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def double_height(data)
    [
      Escpos.sequence(Escpos::TXT_2HEIGHT),
      data,
      Escpos.sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def quad_text(data)
    [
      Escpos.sequence(Escpos::TXT_4SQUARE),
      data,
      Escpos.sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def double_width(data)
    [
      Escpos.sequence(Escpos::TXT_2WIDTH),
      data,
      Escpos.sequence(Escpos::TXT_NORMAL),
    ].join
  end

  def underline(data)
    [
      Escpos.sequence(Escpos::TXT_UNDERL_ON),
      data,
      Escpos.sequence(Escpos::TXT_UNDERL_OFF),
    ].join
  end

  def underline2(data)
    [
      Escpos.sequence(Escpos::TXT_UNDERL2_ON),
      data,
      Escpos.sequence(Escpos::TXT_UNDERL_OFF),
    ].join
  end

  def bold(data)
    [
      Escpos.sequence(Escpos::TXT_BOLD_ON),
      data,
      Escpos.sequence(Escpos::TXT_BOLD_OFF),
    ].join
  end

  def left(data = '')
    [
      Escpos.sequence(Escpos::TXT_ALIGN_LT),
      data,
      Escpos.sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def right(data = '')
    [
      Escpos.sequence(Escpos::TXT_ALIGN_RT),
      data,
      Escpos.sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def center(data = '')
    [
      Escpos.sequence(Escpos::TXT_ALIGN_CT),
      data,
      Escpos.sequence(Escpos::TXT_ALIGN_LT),
    ].join
  end

  def inverted(data)
    [
      Escpos.sequence(Escpos::TXT_INVERT_ON),
      data,
      Escpos.sequence(Escpos::TXT_INVERT_OFF),
    ].join
  end

  def black
    [
      Escpos.sequence(Escpos::TXT_COLOR_BLACK),
      data,
      Escpos.sequence(Escpos::TXT_COLOR_BLACK),
    ].join
  end

  def red
    [
      Escpos.sequence(Escpos::TXT_COLOR_BLACK),
      data,
      Escpos.sequence(Escpos::TXT_COLOR_RED),
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
      Escpos.sequence(text_position),
      Escpos.sequence(Escpos::BARCODE_WIDTH),
      Escpos.sequence([width]),
      Escpos.sequence(Escpos::BARCODE_HEIGHT),
      Escpos.sequence([height]),
      Escpos.sequence(opts.fetch(:format, Escpos::BARCODE_EAN13)),
      data
    ].join
  end

  def partial_cut
    Escpos.sequence(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut
    Escpos.sequence(Escpos::PAPER_FULL_CUT)
  end

end
