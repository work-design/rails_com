module RailsCom::TreeHelper

  # first locals must be node
  def draw_tree(object:, partial:, **options)
    str = ''

    object.children.each do |child|
      concat(render partial: partial, **options)

      if child.children.any?
        draw_tree(partial: partial, **options)
      end
    end

    str
  end

end
