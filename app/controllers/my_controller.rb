class MyController < ApplicationController
  include Com::Controller::Admin
  before_action :require_user

end
