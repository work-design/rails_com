# frozen_string_literal: true

require 'default_form/builder/wrap'
require 'default_form/builder/default'
require 'default_form/builder/helper'
require 'default_form/config'

class DefaultForm::FormBuilder < ActionView::Helpers::FormBuilder
  include DefaultForm::Builder::Helper
  attr_reader :origin_css, :wrap_css, :all_css, :error_css, :offset_css, :after_css, :on_options, :params
  delegate :content_tag, to: :@template

  def initialize(object_name, object, template, options)
    if options.key?(:theme)
      @theme = options[:theme].to_s
    else
      @theme = 'default'
    end
    set_file = Rails.root.join('config/default_form.yml').existence || RailsCom::Engine.root.join('config/default_form.yml')
    set = YAML.unsafe_load_file set_file
    settings = set.fetch(@theme, {})
    settings.deep_symbolize_keys!

    options[:method] = settings[:method] if !options.key?(:method) && settings.key?(:method)

    @origin_css = settings.fetch(:origin, {}).merge options.fetch(:origin, {})
    @wrap_css = settings.fetch(:wrap, {}).merge options.fetch(:wrap, {})
    @all_css = settings.fetch(:all, {}).merge options.fetch(:all, {})
    @error_css = settings.fetch(:error, {}).merge options.fetch(:error, {})
    @offset_css = settings.fetch(:offset, {}).merge options.fetch(:offset, {})
    @after_css = settings.fetch(:after, {}).merge options.fetch(:after, {})
    @on_options = settings.extract! :autocomplete, :autofilter, :placeholder, :label
    @on_options.merge! options.slice(:placeholder, :label, :autocomplete, :autofilter)
    @params = template.params

    _values = Hash(params.permit(object_name => {})[object_name])
    if object.is_a?(ActiveRecord::Base)
      object.assign_attributes _values.slice(*object.attribute_names)
    end

    if options[:class].to_s.start_with?('new_', 'edit_')
      options[:class] = origin_css[:form]
    end
    options[:class] = origin_css[:form] unless options.key?(:class)

    super
  end

  def submit_default_value
    I18n.t "helpers.submit.#{@theme}", raise: true
  rescue
    super
  end

end
