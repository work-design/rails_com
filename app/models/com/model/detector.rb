# frozen_string_literal: true
module Com
  module Model::Detector
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :url, :string

      has_many :detector_errors
    end

    def detect
      r = HTTPX.get url

      if r.error
        self.detector_errors.create(error: r.error.to_s)
      elsif r.status >= 300
        self.detector_errors.create(status: r.status, body: r.body.to_s)
      end
    end

  end
end
