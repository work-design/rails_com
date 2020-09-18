require 'rails_com/utils/setting'

module RailsComExt::Parameter
  extend ActiveSupport::Concern

  included do
    attribute :parameters, :json, default: {}
  end

  def form_parameters
    r = parameters.map { |k, v| { key: k, value: v } }
    if r.blank?
      r = [{ key: nil, value: nil }]
    end
    RailsCom::Settings.new(r)
  end

end
