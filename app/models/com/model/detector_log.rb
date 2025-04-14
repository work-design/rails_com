# frozen_string_literal: true
module Com
  module Model::DetectorLog
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :status, :string
      attribute :body, :string
      attribute :error, :string
      attribute :started_at, :datetime

      belongs_to :detector
      has_many :detector_bots, primary_key: :detector_id, foreign_key: :detector_id
    end


  end
end
