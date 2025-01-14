module Roled
  module Model::WhoRole::WhoMemberRole
    extend ActiveSupport::Concern

    included do
      belongs_to :role, class_name: 'MemberRole'

    end

  end
end
