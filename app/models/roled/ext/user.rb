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

    def old_admin?
      if respond_to?(:account_identities) && (RailsCom.config.default_admin_accounts & account_identities).length > 0
        true
      elsif respond_to?(:identity) && RailsCom.config.default_admin_accounts.include?(identity)
        true
      elsif method(:admin?).super_method
        super
      end
    end

  end
end
