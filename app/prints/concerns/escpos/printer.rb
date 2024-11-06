require "base64"

module Escpos
  class Printer

    attr_reader :data

    def initialize
      # ensure only supported sequences are generated
      @data = "".force_encoding("ASCII-8BIT")
      @data << Escpos.sequence(HW_INIT)
    end

    def write(data)
      escpos_data = data.respond_to?(:to_escpos) ? data.to_escpos : data
      @data << escpos_data.force_encoding("ASCII-8BIT")
    end
    alias :<< :write

    def partial_cut!
      @data << Escpos.sequence(PAPER_PARTIAL_CUT)
    end

    def cut!
      @data << Escpos.sequence(PAPER_FULL_CUT)
    end

    def to_escpos
      @data
    end

  end
end
