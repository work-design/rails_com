class ApplicationController < ActionController::Base
  include RailsCom::Application
  
  protect_from_forgery with: :exception

end unless defined? ApplicationController
