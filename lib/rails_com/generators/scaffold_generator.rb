require 'rails/generators'
require 'rails/generators/erb/scaffold/scaffold_generator'

class Erb::Generators::ScaffoldGenerator
  source_root File.expand_path('../../templates/erb/scaffold', __dir__)

  undef available_views
  private
  def available_views
    ['index', 'edit', 'show', 'new', '_form', '_search_form']
  end

end


