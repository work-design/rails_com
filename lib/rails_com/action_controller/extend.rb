module RailsCom::ActionController
  module Extend

    def whether_filter_role(action_name)
      callback = self.get_callbacks(:process_action).find { |i| i.filter == :require_role }
      return false unless callback

      _if = callback.instance_variable_get(:@if).map do |c|
        c.instance_variable_get(:@actions).include? action_name
      end

      _unless = callback.instance_variable_get(:@unless).map do |c|
        c.instance_variable_get(:@actions).exclude? action_name
      end

      (_if + _unless).exclude?(false)
    end

  end
end

ActiveSupport.on_load :action_controller do
  extend RailsCom::ActionController::Extend
end
