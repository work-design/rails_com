require 'rails/generators'
require 'rails/generators/erb/scaffold/scaffold_generator'

class Erb::Generators::ScaffoldGenerator
  source_root File.expand_path('templates/scaffold_erb', __dir__)

  def copy_view_files
    available_views = [
      'index.html',
      'edit.html',
      'edit.js',
      'show.html',
      'show.js',
      'new.html',
      'new.js',
      '_form.html',
      '_filter.html',
      '_show_table.html'
    ]

    available_views.each do |view|
      filename = [view, handler].compact.join('.')
      template filename, File.join('app/views', controller_file_path, filename)
    end
  end

end


