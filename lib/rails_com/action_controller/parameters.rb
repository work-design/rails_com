module RailsCom::Parameters

  def require(key)
    begin
      super
    ensure
      @required_params ||= []
      @required_params << key
    end
  end

end

ActiveSupport.on_load :action_controller_base do
  ActionController::Parameters.prepend RailsCom::Parameters
end
