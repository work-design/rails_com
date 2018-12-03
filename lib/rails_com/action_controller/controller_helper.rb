module RailsCom::ControllerHelper

  def detect_filter(filter)
    callback = self.__callbacks[:process_action].find { |i| i.filter == filter.to_sym }
    return false unless callback

    _if = callback.instance_variable_get(:@if).map do |c|
      c.call(self)
    end

    _unless = callback.instance_variable_get(:@unless).map do |c|
      !c.call(self)
    end

    !(_if + _unless).uniq.include?(false)
  end

end

ActiveSupport.on_load :action_controller_base do
  include RailsCom::ControllerHelper
end
