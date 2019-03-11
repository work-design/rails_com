require 'rails/generators'
module RailsCom::NamedBase

  def class_name
    file_name.classify
  end

  def singular_route_name
    class_path[-1].to_s + singular_name
  end

  def plural_route_name
    class_path[-1].to_s + plural_name
  end

end

Rails::Generators::NamedBase.prepend RailsCom::NamedBase
