class CommonController < ApplicationController

  def locales
    respond_to do |format|
      format.html
      format.js
    end
  end

  def not_found
    params.permit!
    RailsCom.not_found_logger.info "#{params[:path]}.#{params[:format]}"

    head :not_found
  end


end
