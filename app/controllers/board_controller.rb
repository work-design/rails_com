unless defined? BoardController
  class BoardController < ApplicationController
    before_action :require_login
  end
end
