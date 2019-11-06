# frozen_string_literal: true

module RailsCom::Info
  extend ActiveSupport::Concern
  included do
    attribute :platform, :string
    
    enum platform: {
      ios: 'ios',
      android: 'android'
    }
  end
  

end
