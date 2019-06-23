module RailsCom::ApplicationRecord
  extend ActiveSupport::Concern
  included do
    self.abstract_class = true
  end

  def error_text
    errors.full_messages.join(', ')
  end
  
end
