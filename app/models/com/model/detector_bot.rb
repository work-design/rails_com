# frozen_string_literal: true
module Com
  module Model::DetectorBot
    extend ActiveSupport::Concern

    included do
      belongs_to :err_bot
      belongs_to :detector
    end

  end
end
