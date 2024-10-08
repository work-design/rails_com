module Roled
  module Ext::User
    extend ActiveSupport::Concern

    included do
      has_many :who_roles, class_name: 'Roled::WhoUserRole', foreign_key: :who_id, dependent: :destroy_async
      include Ext::Base
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

    def default_role_hash
      Rails.cache.fetch('user_role_hash') do
        UserRole.find_by(default: true)&.role_hash || {}
      end
    end

  end
end
