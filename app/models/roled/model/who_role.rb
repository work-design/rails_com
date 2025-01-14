module Roled
  module Model::WhoRole
    extend ActiveSupport::Concern

    included do
      attribute :type, :string

      has_many :role_rules, primary_key: :role_id, foreign_key: :role_id
      has_many :tabs, primary_key: :role_id, foreign_key: :role_id

      after_create :compute_role_str!
      after_destroy :compute_role_str!
    end

    def compute_role_str!
      who.compute_role_str!
    end

  end
end
