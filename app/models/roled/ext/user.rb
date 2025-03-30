module Roled
  module Ext::User
    extend ActiveSupport::Concern

    included do
      include Ext::Base
      attribute :admin, :boolean, default: false
    end

    def visible_roles
      Role.joins(:role_types).where(role_types: { who_type: 'Auth::User' }).visible
    end

    def admin?
      id == 1 || super
    end

  end
end
