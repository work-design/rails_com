module RailsCom::ActiveHelper

  # active_assert('notice' == 'notice', expected: 'ui info message', unexpected: 'ui negative message')
  def active_assert(assert, expected: 'item active', unexpected: 'item')
    if assert
      expected
    else
      unexpected
    end
  end

  def active_helper(controller: [], path: [], active_class: 'item active', item_class: 'item')
    if path.present?
      return active_class if path.include?(request.path)
    end

    if controller.present?
      controller.include?(controller_name) ? active_class : item_class
    else
      item_class
    end
  end

  def active_action(controller, *action, active_class: 'item active', item_class: 'item')
    if controller == controller_name && action.include?(action_name)
      active_class
    else
      item_class
    end
  end

  # active_page controller: 'users', action: 'show', id: 371
  def active_page(options)
    active_class = options.delete(:active_class) || 'item active'
    item_class = options.delete(:item_class) || 'item'

    options.select { |_, v| v.blank? }.each do |k, v|
      if params[k].to_s == v.to_s
        return active_class
      else
        return item_class
      end
    end

    current_page?(options) ? active_class : item_class
  end

  def active_params(options)
    active_class = options.delete(:active_class) || 'item active'
    item_class = options.delete(:item_class) || 'item'

    options.select { |_, v| v.present? }.each do |k, v|
      if params[k].to_s == v.to_s
        return active_class
      end
    end

    item_class
  end

  def filter_params(options = {})
    except = options.delete(:except)
    only = options.delete(:only)
    query = request.GET.dup

    if only.present?
      query.slice!(*only)
    else
      excepts = []
      if except.is_a? Array
        excepts += except
      else
        excepts << except
      end
      excepts += ['commit', 'utf8', 'page']

      query.except!(*excepts)
    end

    query.merge!(options)
    query.reject! { |_, value| value.blank? }
    query
  end

end