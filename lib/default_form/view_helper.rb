# frozen_string_literal: true

require 'default_form/form_builder'
module DefaultForm::ViewHelper

  def form_object(record = nil, builder: DefaultForm::FormBuilder, **options)
    object_name = options[:scope].to_s

    if object_name.blank? && record.is_a?(ActiveRecord::Base)
      object_name = record.class.base_class.model_name.param_key
    end

    builder.new(object_name, record, self, options)
  end

  # theme: :default
  def form_with(**options, &block)
    if options[:theme].present? && options[:theme].end_with?('search')
      options[:url] = url_for unless options.key?(:url)
      options[:scope] = '' unless options.key?(:scope)
    end

    super
  end

  # todo support dynamic keys
  def xx_form_with(**options, &block)
    options[:model] = ActiveSupport::InheritableOptions.new(_values.symbolize_keys) unless options.key?(:model)

    form_with(**options, &block)
  end

end

ActiveSupport.on_load :action_view do
 include DefaultForm::ViewHelper
end
