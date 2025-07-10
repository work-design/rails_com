module Roled
  module Ext::Member
    include Ext::Base
    extend ActiveSupport::Concern

    def visible_roles
      Role.joins(:role_types).where(role_types: { who_type: 'Org::Member' }).visible
    end

  end
end
