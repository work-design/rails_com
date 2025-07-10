module Roled
  module Ext::Organ
    extend ActiveSupport::Concern
    include Ext::Base

    def visible_roles
      self.class.visible_roles
    end

    class_methods do
      def visible_roles
        Role.joins(:role_types).where(role_types: { who_type: 'Org::Organ' }).visible
      end
    end

  end
end
