unless defined? PanelController
  class PanelController < ApplicationController
  	before_action :require_login if defined? RailsAuth
    after_action :set_flash, only: %i[update create destroy]
  end
end
