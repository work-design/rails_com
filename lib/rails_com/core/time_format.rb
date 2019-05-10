# frozen_string_literal: true

Time::DATE_FORMATS[:date] = ->(time){
  t = Time.zone.at time
  t.strftime '%Y-%m-%d'
}
Time::DATE_FORMATS[:datetime] = '%Y-%m-%d %H:%M'
Date::DATE_FORMATS[:week] = ->(date){
  I18n.t('date.day_names')[date.wday]
}
