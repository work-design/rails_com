# frozen_string_literal: true

module RailsCom::ActiveHelper
  # return value by each keys which is true
  #   active_asserts(active: true, item: false)
  #   #=> 'active'
  def active_asserts(join = true, **options)
    keys = options.select { |_, v| v }.keys

    if join
      keys.join(' ')
    else
      keys.last.to_s
    end
  end

  # See examples bellow:
  # paths:
  #   active_helper paths: '/work/employees' or active_helper paths: ['/work/employees']
  # controllers:
  #   active_helper controllers: 'xxx'  or active_helper controllers: ['xxx1', 'admin/xxx2']
  # modules:
  #   active_helper modules: 'admin/oa'
  # action:
  #   active_helper 'work/employee': ['index', 'show']
  # params:
  #   active_helper controller: 'users', action: 'show', id: 371
  def active_helper(paths: [], controllers: [], modules: [], active: nil, item: nil, **options)
    check_parameters = options.delete(:check_parameters)

    if paths.present?
      Array(paths).each do |path|
        return active if current_page?(path, check_parameters: check_parameters)
      end
    end

    if controllers.present?
      return active if (Array(controllers) & [controller_name, controller_path]).size.positive?
    end

    if modules.present?
      this_modules = controller_path.split('/')
      this_modules.pop
      active_modules = this_modules.map.with_index { |_, index| this_modules[0, index + 1].join('/') }
      return active if (Array(modules) & active_modules).size.positive?
    end

    return active if options.present? && current_page?(options)

    options.select { |k, _| [controller_name, controller_path].include?(k.to_s) }.each do |_, value|
      return active if Array(value).include?(action_name)
    end

    item
  end

  # return value by params
  #   active_params state: 'xxx', organ_id: 1
  def active_params(active: nil, item: nil, **options)
    options.compact.each do |k, v|
      return active if params[k].to_s == v.to_s

      return active if !params.key?(k) && session[k].to_s == v.to_s
    end

    item
  end

  def filter_params(options = {})
    only = Array(options.delete(:only)).presence
    except = Array(options.delete(:except))
    query = request.GET.dup
    query.merge!(options)

    if only
      query = query.extract!(*only)
    else
      excepts = except.map(&:to_s) + %w[commit utf8 page]
      query.except!(*excepts)
    end

    if query.length > 1
      query.reject! { |_, value| value.blank? }
    else
      query.reject! { |_, value| value.nil? }
    end
    query
  end
end
