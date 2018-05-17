module RailsCom::Controllers
  extend self

  def controller controller_path
    (controller_path + '_controller').classify.constantize
  end

end