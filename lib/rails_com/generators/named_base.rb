require 'rails/generators'
class Rails::Generators::NamedBase

  undef class_name
  private
  def class_name
    file_name.classify
  end

end
