module RailsCom::ActionController
  module Include
    def whether_filter(filter)
      callback = self.__callbacks[:process_action].find { |i| i.filter == filter.to_sym }
      return false unless callback

      if_condition = callback.instance_variable_get(:@if).map do |c|
        c.call(self)
      end

      unless_condition = callback.instance_variable_get(:@unless).map do |c|
        !c.call(self)
      end

      !(if_condition + unless_condition).uniq.include?(false)
    end

    def valid_ivars
      except_condition = _protected_ivars.to_a + [
        :@marked_for_same_origin_verification
      ]
      self.instance_variables - except_condition
    end
  end
end

ActiveSupport.on_load :action_controller do
  include RailsCom::ActionController::Include
end
