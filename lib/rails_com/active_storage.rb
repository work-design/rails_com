# frozen_string_literal: true

require_relative 'active_storage/activestorage_attached'
require_relative 'active_storage/attached_macros'
require_relative 'active_storage/attachment_transfer'
require_relative 'active_storage/attachment_prepend'
require_relative 'active_storage/video_response'
require_relative 'active_storage/blob_prepend'

ActiveStorage.mattr_accessor :service_urls_expire_in, default: 5.minutes
ActiveSupport.on_load(:active_storage_blob) do
  config_choice = Rails.configuration.active_storage.private_service
  if config_choice
    configs = Rails.configuration.active_storage.service_configurations
    ActiveStorage::Blob.private_service = ActiveStorage::Service.configure config_choice, configs
  end
  ActiveStorage::Current.host = SETTING['host'] if defined? SETTING
end
