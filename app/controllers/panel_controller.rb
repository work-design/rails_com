class PanelController < ApplicationController
  include Com::Controller::Admin
  after_action :set_flash, only: [:update, :create, :destroy]

end
