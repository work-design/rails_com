module Roled
  module Ext::User
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoUserRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
    end

    def all_roles
      default_roles = UserRole.where(default: true)

      roles.where.not(id: default_roles.pluck(:id)) + default_roles
    end

    def admin?
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
