class ApplicationController < ActionController::Base
  include RailsAuth::Controller
  include RailsCom::Controller
  include RailsOrg::Controller
  include RailsRole::Controller
  protect_from_forgery with: :exception
  content_security_policy false

end unless defined? ApplicationController
