module StateMachine

  # obj.process_to state: 'xxx'
  def process_to(options = {}, &block)
    options.each do |column, value|
      next_state = next_states(column, &block).first

      if next_state == value.to_s
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be #{next_state}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
  end

  def process_to!(options = {}, &block)
    self.process_to(options, &block)
    self.save!
  end

  def jump_to!(options = {}, &block)
    self.jump_to(options, &block)
    self.save!
  end

  def jump_to(options = {}, &block)
    options.each do |column, value|
      next_states = next_states(column, &block)

      if next_states.include?(value.to_s)
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be one of #{next_states.join(', ')}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
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