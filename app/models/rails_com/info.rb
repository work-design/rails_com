class Info < ApplicationRecord

  enum platform: {
    ios: 'ios',
    android: 'android'
  }

end
