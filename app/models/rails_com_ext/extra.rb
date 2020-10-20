require 'rails_com/utils/setting'

module RailsComExt::Extra
  extend ActiveSupport::Concern

  included do
    attribute :extra, :json, default: {}
  end

  def form_extra
    r = {}
    extra.each do |k, v|
      r.merge! k => v.send(RailsCom.config.mapping.dig(taxon.parameters[k].to_sym, :output))
    end

    RailsCom::Setting.new(r)
  end

end
