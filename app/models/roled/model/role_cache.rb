module Roled
  module Model::RoleCache
    extend ActiveSupport::Concern

    included do
      belongs_to :role
      belongs_to :cache
    end

    def compute_role_str!
      who.compute_role_str!
    end

  end
end
