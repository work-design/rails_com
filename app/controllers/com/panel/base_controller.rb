unless defined? Com::Panel::BaseController
  class Com::Panel::BaseController < PanelController
    include ActiveStorage::SetCurrent
  end
end
