module Roled
  module Controller::Admin

    def rails_role_user
      logger.debug "\e[35m  Role User: User  \e[0m"
      defined?(current_member) && current_member
    end

  end
end
