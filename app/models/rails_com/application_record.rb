module RailsCom::ApplicationRecord
  extend ActiveSupport::Concern
  included do
    self.abstract_class = true
  end

  def error_text
    errors.full_messages.join("\n")
  end
  
  def class_name
    self.class.base_class.name
  end
  
end
