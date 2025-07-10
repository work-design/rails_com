module Roled
  module Ext::User
    include Ext::Base
    extend ActiveSupport::Concern

    included do
      attribute :admin, :boolean, default: false
    end

    def visible_roles
      self.class.visible_roles
    end

    def admin?
      id == 1 || super
    end

    class_methods do
      def visible_roles
        Role.joins(:role_types).where(role_types: { who_type: 'Auth::User' }).visible
      end
    end

  end
end
