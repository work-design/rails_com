module Roled
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :role_whos, class_name: 'Roled::RoleWho', as: :who
      has_many :who_roles, class_name: 'Roled::WhoMemberRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def all_roles
      member_roles = MemberRole.where(default: true)

      roles.where.not(id: member_roles.map(&:id)) + member_roles
    end

  end
end
