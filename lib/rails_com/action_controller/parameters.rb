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

ActionController::Parameters.prepend RailsCom::Parameters
