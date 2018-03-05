class CommonController < ApplicationController

  def locales
    respond_to do |format|
      format.html
      format.js
    end
  end

end
