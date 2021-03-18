class PanelController < ApplicationController
  before_action :require_login if defined? RailsAuth
  after_action :set_flash, only: [:update, :create, :destroy]
end
