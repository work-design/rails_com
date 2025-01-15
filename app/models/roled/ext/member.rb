module Roled
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoMemberRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def visible_roles
      Role.joins(:role_types).where(role_types: { who_type: 'Org::Member' }).visible
    end

  end
end
