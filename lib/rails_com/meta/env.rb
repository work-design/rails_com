module RailsCom::Env
  extend self

  def environments
    Dir.children(Rails.root.join('config', 'environments')).map! { |rb| rb.delete_suffix!('.rb') }
  end

end
