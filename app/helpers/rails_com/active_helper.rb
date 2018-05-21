# frozen_string_literal: true
module RailsCom::ActiveHelper

  # active_assert('notice' == 'notice', expected: 'ui info message', unexpected: 'ui negative message')
  def active_assert(assert, expected: 'item active', unexpected: 'item')
    if assert
      expected
    else
      unexpected
    end
  end

  # active_asserts('active': true, expected: false)
  def active_asserts(join: true, **options)
    keys = options.select { |_, v| v }.keys

    if join
      keys.join(' ')
    else
      keys.last.to_s
    end
  end

  # paths: active_helper paths: '/work/employees' or active_helper paths: ['/work/employees']
  # controllers: active_helper controllers: 'xxx'  or active_helper controllers: ['xxx1', 'admin/xxx2']
  # modules: active_helper modules: 'admin/oa'
  # action: active_helper 'work/employee': ['index', 'show']
  # params: active_params state: 'xxx'
  # active_helper controller: 'users', action: 'show', id: 371
  def active_helper(paths: [], controllers: [], modules: [], active_class: 'item active', item_class: 'item', **options)
    check_parameters = options.delete(:check_parameters)

    if paths.present?
      Array(paths).each do |path|
        return active_class if current_page?(path, check_parameters: check_parameters)
      end
    end

    if controllers.present?
      return active_class if (Array(controllers) & [controller_name, controller_path]).size > 0
    end

    if modules.present?
      this_modules = controller_path.split('/')
      this_modules.pop
      _this_modules = this_modules.map.with_index { |_, index| this_modules[0, index + 1].join('/') }
      return active_class if (Array(modules) & _this_modules).size > 0
    end

    return active_class if options.present? && current_page?(options)

    options.select { |k, _| [controller_name, controller_path].include?(k.to_s) }.each do |_, value|
      return active_class if Array(value).include?(action_name)
    end

    item_class
  end

  def active_params(active_class: 'item active', item_class: 'item', **options)
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
    query = ActionController::Parameters.new(request.GET)
    query.merge!(options)

    if only
      query = query.permit(only)
    else
      excepts = []
      excepts += (Array(except) & request.GET.keys)
      excepts += ['commit', 'utf8', 'page']

      query = query.permit!.except(*excepts)
    end

    query.reject! { |_, value| value.blank? }
    query
  end

end