module Roled
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoMemberRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def all_roles
      roles.or(MemberRole.where(default: true))
    end

  end
end
