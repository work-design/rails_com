require 'rails_com/utils/setting'

module RailsComExt::Extra
  extend ActiveSupport::Concern

  included do
    attribute :extra, :json, default: {}
  end

  def form_parameters
    r = Hash(parameters).map { |k, v| { key: k, value: v } }
    if r.blank?
      r = [{ key: nil, value: nil }]
    end
    RailsCom::Settings.new(r)
  end

end
