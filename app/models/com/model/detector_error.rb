# frozen_string_literal: true
module Com
  module Model::DetectorError
    extend ActiveSupport::Concern

    included do
      attribute :status, :string
      attribute :body, :string
      attribute :error, :string

      belongs_to :detector
    end

  end
end
