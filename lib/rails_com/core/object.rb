# frozen_string_literal: true

class Object
  def to_format_yaml
    to_yaml.delete_prefix("---\n")
  end
end