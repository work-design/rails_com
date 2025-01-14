module Roled
  module Model::Cache
    extend ActiveSupport::Concern

    included do
      attribute :str_role_ids, :string, index: true
      attribute :role_hash, :json, default: {}

      has_many :cache_roles
      has_many :roles, through: :cache_roles

      after_save :sync_role_caches, if: -> { saved_change_to_str_role_ids? }
    end

    def sync_role_caches
      self.role_ids = str_role_ids.split(',')
      reset_role_hash!
    end

    def reset_role_hash!
      cache.role_hash = compute_role_hash
      cache.save
    end

    def compute_role_hash
      roles.each_with_object({}) do |role, h|
        h.deep_merge! role.role_hash
      end
    end

  end
end
