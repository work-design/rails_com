class BoardController < ApplicationController
  before_action :require_login
end unless defined? BoardController
