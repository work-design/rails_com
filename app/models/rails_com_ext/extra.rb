require 'rails_com/utils/setting'

module RailsComExt::Extra
  extend ActiveSupport::Concern

  included do
    attribute :extra, :json, default: {}
  end

  def form_parameters
    RailsCom::Settings.new(extra)
  end

end
