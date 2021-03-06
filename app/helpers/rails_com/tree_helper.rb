module RailsCom::TreeHelper

  # first locals must be node
  def draw_tree(partial:, locals:, **options)
    str = ''

    locals[:model].children.each do |child|
      locals[:model] = child
      concat(render partial: partial, locals: locals, **options)

      if child.children.any?
        draw_tree(partial: partial, locals: locals, **options)
      end
    end

    str
  end

end
