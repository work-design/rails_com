# frozen_string_literal: true
class Com::PdfsController < Com::BaseController
  before_action :set_pdf, only: [:show, :png]

  def show
    disposition = params[:disposition] || 'inline'
    @pdf ||= @pdf_class.new(**pdf_params)
    send_data @pdf.render, filename: 'cert_file.pdf', disposition: disposition, type: 'application/pdf'
  end
  
  def png
    disposition = params[:disposition] || 'inline'
    @pdf ||= @pdf_class.new(**pdf_params)
    require 'vips'
    buffer = Vips::Image.new_from_buffer @pdf.render, ''
    
    send_data buffer.write_to_buffer('.png'), filename: 'cert_file.png', disposition: disposition, type: 'image/png'
  end

  private
  def set_pdf
    @pdf_class = params[:id].constantize
  end
  
  def pdf_params
    keys = @pdf_class.instance_method(:initialize).parameters.to_array_h.to_combine_h[:key]
    params.permit(*keys).to_h.symbolize_keys
  end

end
