module Roled
  module Model::WhoRole::WhoUserRole
    extend ActiveSupport::Concern

    included do
      belongs_to :role, class_name: 'UserRole'
    end

  end
end
