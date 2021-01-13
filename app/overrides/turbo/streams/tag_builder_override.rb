Turbo::Streams::TagBuilder.class_eval do

  def after(target, content = nil, **rendering, &block)
    action :after, target, content, **rendering, &block
  end

end
