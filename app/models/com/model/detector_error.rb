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
      has_many :err_bots, through: :detector_bots

      after_create_commit :send_notice
    end

    def send_notice

    end

  end
end
