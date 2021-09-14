# frozen_string_literal: true

require 'rails_com/active_storage/activestorage_attached'
require 'rails_com/active_storage/attached_macros'
require 'rails_com/active_storage/attachment_transfer'
require 'rails_com/active_storage/attachment_prepend'
require 'rails_com/active_storage/video_response'

ActiveStorage.mattr_accessor :service_urls_expire_in, default: 5.minutes
