module Roled
  module Model::WhoRole::WhoOrganRole
    extend ActiveSupport::Concern

    included do
      belongs_to :role, class_name: 'OrganRole'
    end

  end
end
