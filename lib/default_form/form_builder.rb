# frozen_string_literal: true

require 'default_form/builder/wrap'
require 'default_form/builder/default'
require 'default_form/builder/helper'
require 'default_form/config'

class DefaultForm::FormBuilder < ActionView::Helpers::FormBuilder
  CSS_KEYS = [:origin, :wrap, :wrap_label, :all, :error, :before_wrap, :after_wrap, :before, :after]
  ON_KEYS = [:label, :placeholder, :autocomplete]
  include DefaultForm::Builder::Helper
  attr_reader :on_options, :params
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
    @css = {}
    CSS_KEYS.each do |key|
      @css[key] = settings.fetch(key, {}).merge options.fetch(key, {})
    end
    form_css = settings.fetch(:form, nil) || options.fetch(:form, nil)
    @on_options = settings.extract! *ON_KEYS
    @on_options.merge! options.slice(*ON_KEYS)
    @params = template.params

    if @theme.end_with?('search') && object.is_a?(ActiveRecord::Base)
      object.reset_attributes
    end

    options[:class] = form_css if options[:class].to_s.start_with?('new_', 'edit_')
    options[:class] = form_css unless options.key?(:class)

    super
  end

  def submit_default_value
    I18n.t "helpers.submit.#{@theme}", raise: true
  rescue
    super
  end

end
