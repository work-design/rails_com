class BaseEsc
  attr_reader :data

  def initialize
    # ensure only supported sequences are generated
    @data = "".force_encoding("ASCII-8BIT")
    @data << EscHelper.sequence(Escpos::HW_INIT)
  end

  def write(data)
    escpos_data = data.respond_to?(:to_escpos) ? data.to_escpos : data
    @data << escpos_data.force_encoding("ASCII-8BIT")
  end
  alias :<< :write

  def partial_cut!
    @data << EscHelper.sequence(Escpos::PAPER_PARTIAL_CUT)
  end

  def cut!
    @data << EscHelper.sequence(Escpos::PAPER_FULL_CUT)
  end

  def render
    to_escpos.bytes.map {|i| i.to_s(16) }.join('')
  end

  def to_escpos
    @data
  end

end
