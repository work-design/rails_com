module Roled
  module Model::WhoRole
    extend ActiveSupport::Concern

    included do
      attribute :type, :string

      has_many :role_rules, primary_key: :role_id, foreign_key: :role_id
      has_many :tabs, primary_key: :role_id, foreign_key: :role_id
    end

  end
end
