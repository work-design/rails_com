# frozen_string_literal: true
module Com
  module Model::DetectorLog::DetectorError
    extend ActiveSupport::Concern

    included do
      attribute :error, :string

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
