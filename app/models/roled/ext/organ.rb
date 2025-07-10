module Roled
  module Ext::Organ
    extend ActiveSupport::Concern
    include Ext::Base

    def visible_roles
      Role.where(role_types: { who_type: 'Org::Organ' }).visible
    end

    class_methods do

    end

  end
end
