# frozen_string_literal: true
module Com
  module Model::BlobDefault
    extend ActiveSupport::Concern

    included do
      attribute :record_class, :string, comment: 'AR 类名，如 User'
      attribute :name, :string, comment: '名称, attach 名称，如：avatar'

      has_one_attached :file

      after_commit :delete_default_cache, on: [:create, :destroy]
      after_update_commit :delete_default_cache
    end

    def delete_default_cache
      r = Rails.cache.delete('blob_default/default')
      logger.debug "Cache key blob_default/default delete: #{r}"
    end

    class_methods do
      def defaults
        Rails.cache.fetch('blob_default/default') do
          BlobDefault.includes(:file_attachment).map do |i|
            ["#{i.record_class}_#{i.name}", i.file_attachment&.blob_id]
          end.compact.to_h
        end
      end

      def cache_clear
        Rails.cache.delete('blob_default/default')
      end
    end

  end
end
