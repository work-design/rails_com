module Roled
  module Ext::User
    extend ActiveSupport::Concern
    include Ext::Base

    included do
      attribute :admin, :boolean, default: false
    end

    def admin?
      id == 1 || super
    end

  end
end
