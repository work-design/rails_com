# frozen_string_literal: true

require 'default_form/form_builder'
module DefaultForm::ViewHelper

  def form_object(model = nil, scope: nil, builder: DefaultForm::FormBuilder, **options)
    model = convert_to_model(model)
    scope ||= model_name_from_record_or_class(model).param_key if model
    instantiate_builder(scope, model, builder: builder, **options)
  end

  # theme: :default
  def form_with(**options, &block)
    options[:url] ||= {}
    options[:data] ||= {}
    role_permit?(options[:url], options[:method])

    # add default controller
    controllers = options.dig(:data, :controller).to_s.split(' ')
    if controllers.present? && !controllers.include?('form')
      options[:data][:controller] += ' form'
    else
      options[:data][:controller] = 'form'
    end

    if options[:theme].present? && options[:theme].end_with?('search')
      options[:url] = url_for unless options.key?(:url)
      options[:scope] = '' unless options.key?(:scope)
      options[:skip_default_ids] = true unless options.key?(:skip_default_ids)
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
