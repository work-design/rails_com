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

  def extra_distance_date(from, to, options = {})
    result = (to - from).to_i

    options = {
      scope: :'date.distance_in_words'
    }.merge!(options)

    I18n.with_options locale: options[:locale], scope: options[:scope] do |locale|
      case result
      when 0
        locale.t :zero
      when 1
        locale.t :one
      when 2
        locale.t :two
      when 3
        locale.t :three
      else
        locale.t :other, count: result
      end
    end
  end

end
