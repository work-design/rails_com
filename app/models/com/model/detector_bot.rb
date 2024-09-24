# frozen_string_literal: true
module Com
  module Model::DetectorBot
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :hook_url, :string

      belongs_to :detector
    end

    def set_content(err)
      err.as_json(only: [:status, :body, :error]).each do |k, v|
        add_column err.class.human_attribute_name(k), v unless v.blank?
      end
      add_column '用户信息', err.user_info.inspect
      add_paragraph(err.exception)
      add_paragraph(err.exception_backtrace[0])
      link_more(
        '详细点击',
        Rails.application.routes.url_for(
          controller: 'com/panel/errs',
          action: 'show',
          err_summary_id: err.err_summary.id,
          id: err.id
        )
      )
    end

  end
end
