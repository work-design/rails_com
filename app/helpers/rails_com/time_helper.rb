# frozen_string_literal: true
module RailsCom::TimeHelper

  def exact_distance_time(from_time, to_time, options = {})
    result = TimeHelper.exact_distance_time(from_time, to_time)

    options = {
      scope: :'datetime.prompts'
    }.merge!(options)

    I18n.with_options locale: options[:locale], scope: options[:scope] do |locale|
      str = ''
      result.each do |k, v|
        if v > 0
          str += v.to_s
          str += locale.t(k)
        end
      end
      str
    end
  end

end
