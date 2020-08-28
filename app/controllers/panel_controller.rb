unless defined? PanelController
  class PanelController < ApplicationController
    after_action :set_flash, only: [:update, :create, :destroy]
  end
end
