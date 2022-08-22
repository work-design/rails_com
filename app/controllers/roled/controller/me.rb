module Roled
  module Controller::Me
    extend ActiveSupport::Concern

    included do
    end

    def rails_role_user
      current_member
    end

  end
end
