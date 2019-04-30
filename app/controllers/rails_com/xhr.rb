module RailsCom::Xhr
  extend ActiveSupport::Concern

  included do

  end

  # process_js
  def process_js
    if self.request.xhr?
      self.response.body = Babel.transform(self.response.body)
    end
  end

end
