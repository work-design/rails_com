class PanelController < ApplicationController
  after_action :set_flash, only: [:update, :create, :destroy]

end unless defined? PanelController
