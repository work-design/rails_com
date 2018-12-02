module PersistenceSneakily

  def save_sneakily!(*args, &block)
    self.method(:create_or_update).super_method.call(*args, &block)
  end

end

ActiveSupport.on_load :active_record do
  include PersistenceSneakily
end