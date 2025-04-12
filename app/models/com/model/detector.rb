# frozen_string_literal: true
module Com
  module Model::Detector
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :url, :string

      has_many :detector_bots
      has_many :detector_logs
      has_many :detector_errors
      has_many :detector_responses

      accepts_nested_attributes_for :detector_bots
    end

    def detect
      r = HTTPX.get url
      started_at = Time.current

      if r.error
        self.detector_errors.create(
          started_at: started_at,
          error: r.error.to_s
        )
      elsif r.status >= 300
        self.detector_errors.create(
          started_at: started_at,
          status: r.status,
          body: r.body.to_s
        )
      else
        self.detector_responses.create(
          started_at: started_at,
          status: r.status,
          body: r.body.to_s
        )
      end
    end

  end
end
