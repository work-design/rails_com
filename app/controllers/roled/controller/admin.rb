module Roled
  module Controller::Admin

    def rails_role_user
      return @rails_role_user if defined? @rails_role_user
      if defined?(current_member) && current_member
        @rails_role_user = current_member
      else
        @rails_role_user = current_user
      end
      logger.debug "\e[35m  Role User: #{@rails_role_user.class_name}/#{@rails_role_user.id}  \e[0m"
      @rails_role_user
    end

  end
end
