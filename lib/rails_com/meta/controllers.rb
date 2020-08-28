# frozen_string_literal: true

module RailsCom::Controllers
  extend self

  def controller(controller_path, action_name)
    controller_class = (controller_path + '_controller').classify.safe_constantize
    return unless controller_class

    controller_instance = controller_class.new
    controller_instance.action_name = action_name
    controller_instance
  end
end
