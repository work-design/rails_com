# frozen_string_literal: true
module Job
  class BaseController < AdminController
    protect_from_forgery with: :exception

  end
end
