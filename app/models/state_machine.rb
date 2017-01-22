module StateMachine

  def process_to(status)
    if verify_changes(status)
      update!(state: self.class.states[status])
    else
      errors.add :state, 'Next state is wrong'
      raise ActiveRecord::Rollback, 'Next state is wrong'
    end
  end

  def verify_changes(status)
    states = self.class.states.keys

    i = states.find_index(self.state)
    n = states[i+1]
    n == status.to_s
  end

end