module StateMachine

  # obj.process_to state: 'xxx'
  def process_to(options = {})
    options.each do |column, value|
      if defined? "next_#{column}_states"
        _next_state = self.send("next_#{column}_states").first
      else
        _next_state = next_state(column)
      end

      if _next_state == value.to_s
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be #{_next_state}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
  end

  def process_to!(options = {})
    self.process_to(options, &block)
    self.save!
  end

  def jump_to(options = {})
    options.each do |column, value|
      if defined? "next_#{column}_states"
        _next_states = self.send "next_#{column}_states"
      else
        _next_states = next_states(column)
      end

      if _next_states.include?(value.to_s)
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be one of #{_next_states.join(', ')}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
  end

  def jump_to!(options = {})
    self.jump_to(options, &block)
    self.save!
  end

  # obj.next_states(:state) do |result|
  #   result.reject
  # end
  def next_states(state_name, &block)
    _states = self.class.send(state_name.to_s.pluralize)
    _states = _states.keys
    _state = self.send(state_name)

    if _state.nil?
      next_index = 0
    else
      i = _states.index(_state)
      next_index = i + 1
    end
    result = _states[next_index..(_states.size - 1)]

    if block_given?
      yield block.call(result)
    else
      result
    end
  end

end