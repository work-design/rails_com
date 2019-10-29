# frozen_string_literal: true
class Com::PdfsController < Com::BaseController
  before_action :set_pdf, only: [:show]

  def show
    disposition = params[:disposition] || 'inline'
    @pdf ||= @pdf_class.new(**pdf_params)
    respond_to do |format|
      format.pdf { send_data @pdf.render, filename: 'cert_file', disposition: disposition, type: 'application/pdf' }
    end
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
