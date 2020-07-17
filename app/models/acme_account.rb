class AcmeAccount < ApplicationRecord
  include RailsCom::AcmeAccount
end unless defined? AcmeAccount
