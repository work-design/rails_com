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
    deal_with_state(options[:state], options, options[:url])

    # add default controller
    controllers = options.dig(:data, :controller).to_s.split(' ')
    if controllers.present? && !controllers.include?('default-valid')
      options[:data][:controller] += ' default-valid'
    else
      options[:data][:controller] = 'default-valid'
    end

    if options[:theme].present? && options[:theme].end_with?('search')
      options[:url] = url_for unless options.key?(:url)
      options[:scope] = '' unless options.key?(:scope)

      # add default action
      actions = options.dig(:data, :action).to_s.split(' ')
      if actions.present? && !actions.include?('default-valid#filter')
        options[:data][:action] += ' default-valid#filter'
      else
        options[:data][:action] = 'default-valid#filter'
      end
    end

    super
  end

  # todo support dynamic keys
  def xx_form_with(**options, &block)
    options[:model] = ActiveSupport::InheritableOptions.new(_values.symbolize_keys) unless options.key?(:model)

    form_with(**options, &block)
  end

  def deal_with_state(state, options, url_options)
    if state == 'enter' && options[:state].blank?
      url_options.merge! return_state: StateUtil.encode(request)
    elsif state == 'redirect_return'
      url_options.merge! redirect_state: StateUtil.encode(request)
    elsif state == 'redirect' && params[:return_state].present?
      url_options.merge! redirect_state: params[:return_state]
    elsif state == 'redirect'
      url_options.merge! redirect_state: StateUtil.encode(request)
    elsif state == 'return' && params[:return_state]
      url_options.merge! StateUtil.decode(params[:return_state])
    elsif params[:return_state]
      url_options.merge! return_state: params[:return_state] if options.respond_to?(:merge!)
    end
  end

end

ActiveSupport.on_load :action_view do
  include DefaultForm::ViewHelper
end
