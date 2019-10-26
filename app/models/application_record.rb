class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end unless defined? ApplicationRecord
