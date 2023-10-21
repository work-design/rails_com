class InController < AdminController
  include Org::Controller::Me if defined? RailsOrg

end
