# frozen_string_literal: true

module Com
  module Model::ErrSummary
    extend ActiveSupport::Concern

    included do
      attribute :controller_name, :string
      attribute :action_name, :string
      attribute :exception_object, :string
      attribute :errs_count, :integer

      has_many :errs, ->(o){ where(action_name: o.action_name, exception_object: o.exception_object) }, primary_key: :controller_name, foreign_key: :controller_name
    end

  end
end
