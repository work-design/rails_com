module RailsCom::Info
  extend ActiveSupport::Concern
  included do
    enum platform: {
      ios: 'ios',
      android: 'android'
    }
  end
  

end
