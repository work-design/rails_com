# frozen_string_literal: true
module Job::Panel
  class BaseController < PanelController
    protect_from_forgery with: :exception

  end
end
