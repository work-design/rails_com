# frozen_string_literal: true

module RailsCom::VariantInclude
  extend ActiveSupport::Concern

  included do
    attribute :variation_digest, :string, null: false
  end
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::VariantRecord.include RailsCom::VariantInclude
end
