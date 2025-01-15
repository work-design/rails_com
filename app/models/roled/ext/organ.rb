module Roled
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoOrganRole', foreign_key: :who_id, inverse_of: :who, dependent: :destroy_async
      accepts_nested_attributes_for :who_roles
      include Ext::Base
    end

    def visible_roles
      Role.joins(:role_types).where(role_types: { who_type: 'Org::Organ' }).visible
    end

  end
end
