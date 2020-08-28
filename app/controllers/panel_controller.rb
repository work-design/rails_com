unless defined? PanelController
  class PanelController < ApplicationController
    after_action :set_flash, only: %i[update create destroy]
  end
end
