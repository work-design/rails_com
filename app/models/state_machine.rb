module StateMachine

  # obj.process_to state: 'xxx'
  def process_to(options = {})
    options.each do |column, value|
      _states = self.class.send(column.to_s.pluralize)
      _states = _states.keys
      _state = self.send(column)

      if _state.nil?
        next_index = 0
      else
        i = _states.index(_state)
        next_index = i + 1
      end
      next_state = _states[next_index]

      if next_state == value.to_s
        assign_attributes(column => value)
        save!
      else
        errors.add column, 'Next state is wrong'
        raise ActiveRecord::Rollback, 'Next state is wrong'
      end
    end
  end

end