module Roled
  module Model::Cache
    extend ActiveSupport::Concern

    included do
      attribute :str_role_ids, :string, index: true
      attribute :role_hash, :json, default: {}
    end

  end
end
