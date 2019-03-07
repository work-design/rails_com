require_relative 'active_storage/activestorage_attached'
require_relative 'active_storage/attached_macros'
require_relative 'active_storage/attachment_transfer'
require_relative 'active_storage/attachment_ext'
require_relative 'active_storage/video_response'
ActiveStorage.mattr_accessor :service_urls_expire_in, default: 5.minutes
