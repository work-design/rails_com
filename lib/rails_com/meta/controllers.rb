# frozen_string_literal: true

module RailsCom::Controllers
  extend self

  def controller(controller_path, action_name)
    controller_class = (controller_path + '_controller').classify.safe_constantize

    if controller_class
      controller = controller_class.new
      controller.action_name = action_name
      controller
    end
  end
end
