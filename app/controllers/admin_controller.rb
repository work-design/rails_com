class AdminController < ApplicationController
  before_action :require_login
  before_action :require_role

end unless defined? AdminController
