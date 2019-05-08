class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def error_text
    errors.full_messages.join(', ')
  end
  
end
