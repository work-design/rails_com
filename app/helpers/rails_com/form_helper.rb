module RailsCom::FormHelper

  def text_field_tag(name, value = nil, options = {})
    if options[:as]
      type = RailsCom.config.mapping[options[:as]][:input]

      if type == 'textarea'
        return text_area_tag(name, value, options)
      end

      if type == 'select'
        opts = RailsCom.config.mapping[options[:as]][:options]
        selected = RailsCom.config.mapping[options[:as]][:selected]
        return select_tag name, options_for_select(opts, selected), options
      end
    end

    super
  end

end
