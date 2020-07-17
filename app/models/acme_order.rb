class AcmeOrder < ApplicationRecord
  include RailsCom::AcmeOrder
end unless defined? AcmeOrder
