module RailsCom
  module UrlHelper

    def button_to(name = nil, options = nil, html_options = nil, &block)
      if name.is_a?(Hash) && block_given?
        name = url_for(name)
      end
      super
    end

  end
end
