class Com::Panel::BaseController < PanelController
  include ActiveStorage::SetCurrent
end unless defined? Com::Panel::BaseController
