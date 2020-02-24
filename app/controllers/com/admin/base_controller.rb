class Com::Admin::BaseController < RailsCom.config.admin_controller.constantize
  include ActiveStorage::SetCurrent

end
