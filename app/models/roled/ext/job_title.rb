module Roled
  module Ext::JobTitle
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoJobTitleRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def visible_roles
      Role.joins(:role_types).where(role_types: { who_type: 'Org::JobTitle' }).visible
    end

  end
end
