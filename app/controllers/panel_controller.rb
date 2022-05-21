class PanelController < ApplicationController
  include Com::Controller::Panel
  after_action :set_flash, only: [:update, :create, :destroy]

end
