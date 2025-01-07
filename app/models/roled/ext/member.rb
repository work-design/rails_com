module Roled
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoMemberRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def role_hash
      roles.or(MemberRole.where(default: true)).each_with_object({}) do |role, h|
        h.deep_merge! role.role_hash
      end
    end

  end
end
