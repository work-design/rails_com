module Roled
  module Model::RoleCache
    extend ActiveSupport::Concern

    included do
      belongs_to :role
      belongs_to :cache
    end

  end
end
