module Roled
  module Model::Cache
    extend ActiveSupport::Concern

    included do
      attribute :str_role_ids, :string, index: true
      attribute :role_hash, :json, default: {}

      has_many :role_caches
    end

    def reset_role_hash!
      cache.role_hash = compute_role_hash
      cache.save
    end

    def all_roles
      Role.where(id: str_role_ids.split(','))
    end

    def compute_role_hash
      all_roles.each_with_object({}) do |role, h|
        h.deep_merge! role.role_hash
      end
    end

  end
end
