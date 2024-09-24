# frozen_string_literal: true
module Com
  module Model::DetectorError
    extend ActiveSupport::Concern

    included do
      attribute :status, :string
      attribute :body, :string
      attribute :error, :string

      belongs_to :detector
      has_many :detector_bots, primary_key: :detector_id, foreign_key: :detector_id

      after_create_commit :send_notice_later
    end

    def send_notice_later
      DetectorErrorJob.perform_later(self)
    end

    def send_notice
      detector_bots.map do |bot|
        bot.send_message(self)
      end
    end

  end
end
