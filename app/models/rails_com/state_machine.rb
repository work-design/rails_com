# frozen_string_literal: true

module RailsCom::StateMachine
  # to defined next_xxx_states in class

  # obj.next_to state: 'xxx'
  def next_to(options = {}, &block)
    options.each do |column, value|
      state = if self.class.method_defined? "next_#{column}_states"
                send("next_#{column}_states").first
              else
                next_state(column, &block)
              end

      if state == value.to_s
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be #{state}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
  end

  def next_to!(options = {}, &block)
    next_to(options, &block)
    save!
  end

  def trigger_to(options = {}, &block)
    options.each do |column, value|
      states = if self.class.method_defined? "next_#{column}_states"
                 send "next_#{column}_states"
               else
                 next_states(column, &block)
               end

      if states.include?(value.to_s)
        assign_attributes(column => value)
      else
        error_msg = "Next state is wrong, should be one of #{states.join(', ')}"
        errors.add column, error_msg
        raise ActiveRecord::Rollback, error_msg
      end
    end
  end

  def trigger_to!(options = {}, &block)
    trigger_to(options, &block)
    save!
  end

  def next_state(state_name, &block)
    next_states(state_name, &block).first
  end

  # obj.next_states(:state) do |result|
  #   result.reject
  # end
  def next_states(state_name, &block)
    states = self.class.send(state_name.to_s.pluralize).keys
    state = send(state_name)

    if state.nil?
      next_index = 0
    else
      i = states.index(state)
      next_index = i + 1
    end
    result = states[next_index..(states.size - 1)]

    if block_given?
      yield block.call(result)
    else
      result
    end
  end
end
