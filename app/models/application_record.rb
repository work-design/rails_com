class ApplicationRecord < ActiveRecord::Base
  include RailsCom::ApplicationRecord
end unless defined? ApplicationRecord
