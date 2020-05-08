class BoardController < ApplicationController
  layout 'my'
  before_action :require_login

end unless defined? BoardController
