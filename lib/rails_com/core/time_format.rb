# frozen_string_literal: true

Time::DATE_FORMATS[:datetime] = '%Y-%m-%d %H:%M'
Time::DATE_FORMATS[:week] = lambda { |time|
  I18n.t('date.day_names')[time.wday]
}
Time::DATE_FORMATS[:date] = lambda { |time|
  t = Time.zone.at time
  t.strftime '%Y-%m-%d'
}
Time::DATE_FORMATS[:month] = lambda { |time|
  I18n.t('date.month_names')[time.month]
}
Date::DATE_FORMATS[:week] = lambda { |date|
  I18n.t('date.day_names')[date.wday]
}
Date::DATE_FORMATS[:month] = lambda { |date|
  I18n.t('date.month_names')[date.month]
}
