module StateMachine

  # obj.process_to state: 'xxx'
  def process_to(options = {})
    options.each do |column, value|
      next_state = next_states(column).first

      if next_state == value.to_s
        assign_attributes(column => value)
        save!
      else
        errors.add column, 'Next state is wrong'
        raise ActiveRecord::Rollback, 'Next state is wrong'
      end
    end
  end

  def jump_to(options = {})
    options.each do |column, value|
      next_states = next_states(column)

      if next_states.include?(value.to_s)
        assign_attributes(column => value)
        save!
      else
        errors.add column, 'Next state is wrong'
        raise ActiveRecord::Rollback, 'Next state is wrong'
      end
    end
  end

  def next_states(state_name)
    _states = self.class.send(state_name.to_s.pluralize)
    _states = _states.keys
    _state = self.send(state_name)

    if _state.nil?
      next_index = 0
    else
      i = _states.index(_state)
      next_index = i + 1
    end
    _states[next_index..(_states.size - 1)]
  end

end