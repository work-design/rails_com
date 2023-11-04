# frozen_string_literal: true

require 'rails_com/active_storage/attached_macros'

ActiveStorage.mattr_accessor :service_urls_expire_in, default: 5.minutes
