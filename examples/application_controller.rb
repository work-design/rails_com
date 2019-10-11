class ApplicationController < ActionController::Base
  include RailsAuth::Application
  include RailsCom::Application
  include RailsOrg::Application
  include RailsRole::Application
  protect_from_forgery with: :exception
  content_security_policy false

end
