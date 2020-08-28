unless defined? ApplicationController
  class ApplicationController < ActionController::Base
    include RailsCom::Application

    protect_from_forgery with: :exception, unless: -> { json_format? }
  end
end
