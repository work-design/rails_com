# frozen_string_literal: true

require 'active_support/configurable'

module DefaultForm
  include ActiveSupport::Configurable

  configure do |config|
    config.theme = 'default'
    config.help_tag = ->(app, text) {
      app.content_tag(:span, aria: { label: text }) do
        app.content_tag(:i, nil, class: 'fas fa-question-circle')
      end
    }
    config.mapping = ActiveSupport::OrderedOptions.new
    config.mapping.date = {
      input: 'date_field',
      output: 'to_date'
    }
    config.mapping.integer = {
      input: 'number_field',
      options: { step: 1 },
      output: 'to_i'
    }
    config.mapping.decimal = {
      input: 'number_field',
      options: { step: 0.01 }
    }
    config.mapping.string = {
      input: 'text_field',
      output: 'to_s'
    }
    config.mapping.text = {
      input: 'text_area',
      output: 'to_s'
    }
    config.mapping.array = {
      input: 'text_field',
      options: { multiple: true },
      output: 'to_s'
    }
    config.mapping.area = {
      input: 'out_select',
      options: { outer: 'area' }
    }
    config.mapping.taxon = {
      input: 'out_select'
    }
    config.mapping.enum = {
      input: 'select_enum'
    }
  end

end
