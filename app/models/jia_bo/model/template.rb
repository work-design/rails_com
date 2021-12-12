module JiaBo
  module Model::Template
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, comment: '模板编号'
      attribute :type, :string, comment: '模板类型'
      attribute :title, :string, comment: '模板名称'
      attribute :thumb_url, :string

      belongs_to :app, counter_cache: true
      has_many :parameters, dependent: :delete_all

      has_one_attached :thumb

      after_save_commit :sync_thumb_later, if: -> { saved_change_to_thumb_url? && thumb_url.present? }
    end

    def sync_thumb_later
      TemplateJob.perform_later(self)
    end

  end
end
